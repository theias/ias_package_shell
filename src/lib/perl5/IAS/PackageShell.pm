package IAS::PackageShell;

use strict;
use warnings;

=head1 NAME

IAS::PackageShell

=head1 SYNOPSIS

See ias_package_shell.pl

=head1 DESCRIPTION

Documentation in this file will be for how IAS::PackageShell is
developed.  ias_package_shell.pl will contain how it's used.

=cut

use Pod::Usage;
use FindBin qw($RealBin $Script);
use Data::Dumper;
$Data::Dumper::Indent = 1;
use Template;
use File::Basename;
use IO::File;
use File::Spec;
use Template;
use JSON;

use Getopt::Long;

our $SUPPRESS_DEFAULT_NOTIFICATIONS=1;
my $OPTIONS_VALUES = {
	'do-post-create-run' => 1,
};
my $OPTIONS=[
	'debug',
	'project-path-output=s',
	'project-control-file=s',
	'project-template-dir=s',
	'do-post-create-run!',
	'dump-stuff!',
];

GetOptions(
	$OPTIONS_VALUES,
	@$OPTIONS,
)
or pod2usage(
	-message => "Invalid options specified.\n"
		. "Please perldoc this file for more information.",
	-exitval => 1
);

our %CONTROL_TRANSFORMS = (
	'underscores_to_dashes' => \&transform_underscores_to_dashes,
	'dashes_to_underscores' => \&transform_dashes_to_underscores,
	'upper_case' => \&transform_to_upper_case,
);

# Layout Awareness

	our @UP_PATH_COMPONENTS;
	our @POST_PATH_COMPONENTS;

	my $SCRIPT_ABS_PATH;
	my @SCRIPT_PATH_PARTS;
	our $PROJECT_NAME;

	our $SCRIPT_WITHOUT_EXTENSION = $Script;
	$SCRIPT_WITHOUT_EXTENSION =~ s/(\.[^.]+)$//;

	our $CHOSEN_BIN = $RealBin;
	$SCRIPT_ABS_PATH = File::Spec->rel2abs($CHOSEN_BIN);
	@SCRIPT_PATH_PARTS = split('/',$SCRIPT_ABS_PATH);
	$PROJECT_NAME = $SCRIPT_PATH_PARTS[-1];

	if($SCRIPT_PATH_PARTS[-2] eq 'src')
	{
		$OPTIONS_VALUES->{'auto-dev-mode'} = 1;
		$PROJECT_NAME = $SCRIPT_PATH_PARTS[-3];
		@UP_PATH_COMPONENTS=($CHOSEN_BIN,'..');
		$PROJECT_NAME = $SCRIPT_PATH_PARTS[-3];
		$PROJECT_NAME =~ s/_/-/g;
		@POST_PATH_COMPONENTS = ();
	}

our $PROJECT_CONTROL_FILE;
our $TEMPLATE_CONFIG = {};

if ($OPTIONS_VALUES->{'auto-dev-mode'})
{
	$PROJECT_CONTROL_FILE="$RealBin/../templates/project_dir.json";
}
else
{
	$PROJECT_CONTROL_FILE="/opt/IAS/templates/ias-package-shell/project_dir.json";
}

our $project_control_file = $OPTIONS_VALUES->{'project-control-file'}
	// $PROJECT_CONTROL_FILE;

my $template_guess_path = $PROJECT_CONTROL_FILE;
$template_guess_path =~ s/\.[^.]+$//;
if ( defined $OPTIONS_VALUES->{'project-control-file'} )
{
	my $tmp_guess_path = $OPTIONS_VALUES->{'project-control-file'};
	$tmp_guess_path =~ s/\.[^.]+$//;

	if (-d $tmp_guess_path)
	{
		$template_guess_path = $tmp_guess_path;
	}
}

our $project_template_path = $OPTIONS_VALUES->{'project-template-dir'}
	// $template_guess_path;

=head1 SUBROUTINES

=cut

sub new
{
	my $type = shift;
	my $self = {};
	return bless $self, $type;
}


sub run
{
	my ($self) = @_;
	
	if (! defined $project_template_path
		|| ! -d $project_template_path )
	{
		die "Please provide a project template path.\n";
	}

	my $project_control_data = load_json_file($project_control_file);

	$self->{project_control_data} = $project_control_data;
	
	$project_control_data->{template_base_dir} =
		remove_double_slashes($project_template_path.'/');

	my $project_info = $self->do_prompts();
	
	$self->{project_info} = $project_info;
	
	$self->do_control_transforms();

	if ($OPTIONS_VALUES->{'dump-stuff'})
	{
		my $json = JSON->new->allow_nonref();
		my %h = %$self;
		print $json->pretty->encode(\%h);
		exit;
	}	

	$self->process_project_dir();

	$self->save_project_data();

	$self->run_post_project_create($project_info)
		if ($OPTIONS_VALUES->{'do-post-create-run'});

	# my $json = JSON->new->allow_nonref();

	# print $json->pretty->encode({
	# 	'project_control_data' => $self->{'project_control_data'},
	# 	'project_info' => $self->{project_info},
	# });

	exit;
}

sub save_project_data
{
	my ($self) = @_;

	return if (! defined $self->{'project_control_data'}->{'save-data'});

	my @data_saves = keys %{$self->{'project_control_data'}->{'save-data'}};

	my $json = JSON->new->allow_nonref();
	my $template = Template->new()
		|| die $Template::ERROR.$/;

	foreach my $data_save (@data_saves)
	{
		my $new_file_name;
		$template->process(
			\$self->{'project_control_data'}->{'save-data'}->{$data_save},
			$self->{'project_info'},
			\$new_file_name
		);

		# print "Would have saved to: $new_file_name\n";

		my $fh = IO::File->new(">$new_file_name")
			or die "Can't open $new_file_name for writing: $!";

		print $fh $json->pretty->encode($self->{$data_save});

		$fh->close();
	}
}
sub remove_front_part
{
	my ($string, $front_part) = @_;
	
	$string =~ s/^\Q$front_part\E//;
	
	return $string;
}

sub remove_double_slashes
{
	my ($string) = @_;
	
	$string =~ s/\/\//\//g;
	
	return $string;
}



sub run_post_project_create
{
	my ($self) = @_;
	my $project_info = $self->{project_info};
	my $project_control_data = $self->{project_control_data};
	
	return if (! defined $project_control_data->{'post-create-run'});

	my $template = Template->new()
		|| die $Template::ERROR.$/;
	
	my $new_post_create_command;
	$template->process(
		\$project_control_data->{'post-create-run'},
		$project_info,
		\$new_post_create_command,
	);
	
	$self->debug("Running post create command:\n$new_post_create_command\n");
	
	`$new_post_create_command`;
}



sub process_project_dir
{
	my ($self) = @_;
	
	my $project_info = $self->{project_info};
	use File::Copy::Recursive qw(rcopy);
	
	local $File::Copy::Recursive::KeepMode = 0;
	
	

	my $project_dir = $project_info->{project_name};
	if (defined $OPTIONS_VALUES->{'project-path-output'})
	{
		$project_dir = join('/',
			$OPTIONS_VALUES->{'project-path-output'},
			$project_info->{project_name},
		);
	}

	$project_info->{'project_dir'} = $project_dir;
	rcopy($project_template_path, $project_dir)
		or die ("Unable to rcopy $project_template_path to $project_dir: $!");

	finddepth(
		{
			wanted => sub {
				$self->rename_path_template($_);
			},
			no_chdir => 1,
		},
		$project_dir,
	);

	use File::Find;

	finddepth(
		{
			no_chdir => 1, 
			wanted => sub {
				$self->process_file_template($_)
			},
		},
		$project_dir
	);

}

sub process_file_template
{
	my ($self,  $source_file_name) = @_;

	my $project_info = $self->{project_info};
	my $project_control_data = $self->{project_control_data};

	my $temp_file_name = File::Temp::tmpnam();
	
	my $template_exclusions = $project_control_data->{'not-template-files-contents'}->{regexes};
	my @exclude_regexes = map {$_->{regex}} @$template_exclusions;
	# $self->debug("Exclusion regexes: ", Dumper(\@exclude_regexes),"\n");
	
	my $project_name_dir = $project_info->{project_name}.'/';
	my $compare_me=remove_front_part($source_file_name,$project_name_dir);
	
	foreach my $exclude_regex (@exclude_regexes)
	{
		# $self->debug("Exclude regex: $exclude_regex\n");
		# $self->debug(print "Compare me: $compare_me\n");
		if ($compare_me =~ m/$exclude_regex/)
		{
			$self->debug("$compare_me matches $exclude_regex.  Not processing as template.\n");
			return;
		}
	}
	return if (! -f $source_file_name);

	$self->debug("Processing file template: $source_file_name",$/);
	$self->debug("Source file: $source_file_name\n");
	$self->debug("Temp file: $temp_file_name\n");

	use File::Temp;
	use File::Copy;
	
	write_template_file(
		$temp_file_name, 
		$source_file_name,
		{
			project => $project_info,
		}
	);
	copy($temp_file_name, $source_file_name);
	unlink($temp_file_name);
}

sub rename_path_template
{
	my ($self, $path) = @_;

	my $project_control_data = $self->{project_control_data};
	my $template_exclusions = $project_control_data->{'not-template-files-paths'}->{regexes};
	my @exclude_regexes = map {$_->{regex}} @$template_exclusions;
	# $self->debug("Exclusion regexes: ", Dumper(\@exclude_regexes),"\n");
	
	my $project_info = $self->{project_info};
	
	my $project_name_dir = $project_info->{project_name}.'/';
	my $compare_me=remove_front_part($path,$project_name_dir);
	
	foreach my $exclude_regex (@exclude_regexes)
	{
		if ($compare_me =~ m/$exclude_regex/)
		{
			$self->debug("$compare_me matches $exclude_regex.  Not processing as template.\n");
			return;
		}
	}

	use File::Basename;
	
	my $template = Template->new()
		|| die $Template::ERROR.$/;
	
	my $basename = basename($path);
	my $dirname = dirname($path);
	$self->debug("Basename: ", $basename,$/);
	$self->debug("Dirname: ", $dirname,$/);
	
	my $new_basename;
	$template->process(
		\$basename,
		{ project => $self->{project_info} },
		\$new_basename,
	);
	my $new_file_name = join('/', $dirname, $new_basename);

	$self->debug("New file name: $new_file_name",$/);
	
	rename($path, $new_file_name);
}





sub debug
{
	my ($self) = @_;
	print @_ if $OPTIONS_VALUES->{debug};
}

=head2 do_prompts

=over 4

=item Asks for user input.
=item Complains if fail_regex matches
=item Complains if pass_regex doesn't match
=item Applies default value if necessary

=back

=cut

sub do_prompts
{
	my ($self) = @_;
	
	my $structure = $self->{project_control_data};
	my $prompts = $structure->{prompts};
	
	my $data = {};
	THIS_PROMPT: foreach my $prompt (@$prompts)
	{
		my $response;
		if (! $prompt->{'dont_prompt'})
		{

			print "####################\n";
			print "#   ",$prompt->{"prompt"},$/;
			
			if ($prompt->{'description'})
			{
				print $prompt->{"description"},$/;
			}
		
			if ( defined ($prompt->{"default_value"}) )
			{
				print 'Default: [',$prompt->{"default_value"},'] ';
			}
			print "Enter Response: ";
		
			$response = <STDIN>;
			chomp($response);
		}

		my $used_default = 0;
		if (
			defined ($prompt->{"default_value"})
			&& (! defined $response || $response =~ m/^\s*/ ) 
		)
		{
			if (! $SUPPRESS_DEFAULT_NOTIFICATIONS)
			{
				print "Using default value for ",$prompt->{'prompt'}, " [",
					$prompt->{'default_value'}, ']',$/;
			}
			$response = $prompt->{"default_value"};
			
			$used_default = 1;
		}
		
		my $fail_regex = $prompt->{'fail_regex'};
		
		if ( $fail_regex && $response =~ m/$fail_regex/)
		{
			print "$response matches fail regex: $fail_regex.  Please try again.\n";
			if ($used_default)
			{
				print "Additionally, the default value appears to be bad.\n";
				$prompt->{'dont_prompt'} = 0;
			}
			redo THIS_PROMPT;
		}
		
		my $pass_regex = $prompt->{'pass_regex'};
		if ($pass_regex && $response !~ m/$pass_regex/)
		{
			print "$response does not match pass regex: $pass_regex.  Please try again.\n";
			if ($used_default)
			{
				print "Additionally, the default value appears to be bad.\n";
				$prompt->{'dont_prompt'} = 0;
			}
			redo THIS_PROMPT;
		}
		
		$data->{$prompt->{'name'}} = $response;
	}
	return $data;
}

sub load_json_file
{
	my ($file_name) = @_;

	my $fh = IO::File->new("<$file_name")
		or die "Can't open $file_name for reading: $!";
	local $/;
	my $whole_file = <$fh>;

	my $json = JSON->new->allow_nonref;
 
	# $json_text   = $json->encode( $perl_scalar );
	return $json->decode( $whole_file );
}

sub write_template_file
{
	my ($output_file_name, $input_file_name, $template_vars_hr) = @_;
	
	# print "Template HR:", Dumper($template_hr),$/;

	my $template = Template->new($TEMPLATE_CONFIG)
		|| die "$Template::ERROR\n";

	$template->process($input_file_name,
		$template_vars_hr,
		$output_file_name,
	) or die $template->error();

}

=head2 Transforms

These are dispatched subroutines that can be specified from the configuration
file.

=cut

sub do_control_transforms
{
	my ($self) = @_;
	
	my $project_control_data = $self->{project_control_data};
	my $project_info = $self->{project_info};

	CONTROL_TRANSFORM: foreach my $transform (@{$project_control_data->{transforms}})
	{
		# print "Start of transform loop!\n";
		if (! defined $CONTROL_TRANSFORMS{$transform->{transform}})
		{
			warn "Transform ", $transform->{transform}, " is not a valid transform.\n";
			next CONTROL_TRANSFORM;
		}
		# print "Transform is defined!\n";
		$project_info->{$transform->{name}} = $CONTROL_TRANSFORMS{$transform->{transform}}->(
			$project_info,
			$transform->{template_string},
		);
	}

}

=head3 transform_underscores_to_dashes

Does just what it says.

=cut

sub transform_underscores_to_dashes
{
	my ($data_ref, $template_string) = @_;

	my $template = Template->new()
		|| die $Template::ERROR.$/;
	my $new_value;
	$template->process(
		\$template_string,
		$data_ref,
		\$new_value,
	);
	
	$new_value =~ s/_/-/g;
	return $new_value;	
}

=head3 transform_dashes_to_underscores

Does just what it says.

=cut

sub transform_dashes_to_underscores
{
	my ($data_ref, $template_string) = @_;

	my $template = Template->new()
		|| die $Template::ERROR.$/;
	my $new_value;
	$template->process(
		\$template_string,
		$data_ref,
		\$new_value,
	);
	
	$new_value =~ s/\-/_/g;

	return $new_value;	
}

=head3 transform_to_upper_case

Does just what it says.

=cut

sub transform_to_upper_case
{
	my ($data_ref, $template_string) = @_;

	my $template = Template->new()
		|| die $Template::ERROR.$/;
	my $new_value;
	$template->process(
		\$template_string,
		$data_ref,
		\$new_value,
	);
	
	$new_value = uc($new_value);

	return $new_value;	
}

1;
