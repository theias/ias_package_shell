#!/usr/bin/perl

# $Id$
=pod

=head1 NAME

ias_package_shell.pl - Creates a project directory that generates an installable package

=head1 SYNOPSIS

  ias_package_shell.pl

=head1 DESCRIPTION

A set of libraries and packaging routines have been set up to automate the process
of creating projects and installing them.  This creates the base project
directories.

=head1 OPTIONS

  [ --project-output-path ] - optionally specify where to drop the project files. 

=cut


use strict;
use warnings;

use Pod::Usage;
use FindBin qw($RealBin $Script);
use Data::Dumper;
use Template;
use File::Basename;
use IO::File;
use File::Spec;
use Template;

use Getopt::Long;
my $DEBUG=1;
our $SUPPRESS_DEFAULT_NOTIFICATIONS=1;
my $OPTIONS_VALUES = {};
my $OPTIONS=[
	'project-path-output=s',
	'project-control-file=s',
	'project-template-path=s',
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

our $TEMPLATE_DIR;
our $PROJECT_CONTROL_FILE;
our $PROJECT_TEMPLATE_DIR;

our $TEMPLATE_CONFIG = {};


if ($OPTIONS_VALUES->{'auto-dev-mode'})
{
	$PROJECT_CONTROL_FILE="$RealBin/../templates/project_dir.json";
	$PROJECT_TEMPLATE_DIR="$RealBin/../templates/project_dir";
}
else
{
	$PROJECT_CONTROL_FILE="/opt/IAS/templates/ias-package-shell/project_dir.json";
	$PROJECT_TEMPLATE_DIR="/opt/IAS/templates/ias-package-shell/project_dir";
}

our $project_control_file = $OPTIONS_VALUES->{'project-control-file'}
	|| $PROJECT_CONTROL_FILE;
	
our $project_template_path = $OPTIONS_VALUES->{'project-template-path'}
	|| $PROJECT_TEMPLATE_DIR;

my $project_info = do_prompts(load_json_file($project_control_file));
process_project_dir($project_info);
run_post_project_create($project_info);

exit;

sub run_post_project_create
{
	my ($project_info) = @_;
	
	my $makefile = $project_info->{'project_dir'}."/Makefile";
	my $project_dir = $project_info->{'project_dir'};
	
	if (-e $makefile)
	{
		`cd $project_dir; make package_shell-project_post_create_cleanup`;
	}
}

sub write_template_file
{
	my ($output_file_name, $input_file_name, $template_vars_hr) = @_;
	
	# print "Template HR:", Dumper($template_hr),$/;

	my $template = new Template($TEMPLATE_CONFIG)
		|| die "$Template::ERROR\n";

	$template->process($input_file_name,
		$template_vars_hr,
		$output_file_name,
	) or die $template->error();

}

sub process_project_dir
{
	use File::Copy::Recursive qw(rcopy);
	
	local $File::Copy::Recursive::KeepMode = 0;
	
	my ($project_info) = @_;

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
				rename_path_template($_, { project => $project_info});
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
				process_file_template($_, $project_info)
			},
		},
		$project_dir
	);

}

sub process_file_template
{
	my ($source_file_name, $project_info) = @_;
	my $temp_file_name = File::Temp::tmpnam();

	debug("Processing file template: $source_file_name",$/);
	
	# use Cwd;
	# print "Cwd: ", getcwd,$/;
	# print "Exists!$/" if (-e $source_file_name);
	
	return if (! -f $source_file_name);
	debug("Source file: $source_file_name\n");
	debug("Temp file: $temp_file_name\n");

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
	my ($path, $template_data) = @_;

	use File::Basename;
	# print "$path",$/;
	
	my $template = new Template()
		|| die $Template::ERROR,$/;
	
	my $basename = basename($path);
	my $dirname = dirname($path);
	debug("Basename: ", $basename,$/);
	debug("Dirname: ", $dirname,$/);
	
	my $new_basename;
	$template->process(
		\$basename,
		$template_data,
		\$new_basename,
	);
	my $new_file_name = join('/', $dirname, $new_basename);

	debug("New file name: $new_file_name",$/);
	
	rename($path, $new_file_name);
}


sub debug
{
	print @_ if ($DEBUG);
}

sub do_prompts
{
	my ($structure) = @_;
	
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
