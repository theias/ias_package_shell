#!/usr/bin/perl

# $Id$
=pod

=head1 NAME

package_shell.pl - Creates a project directory that generates an installable package

=head1 SYNOPSIS

  package_shell.pl
  
=head1 DESCRIPTION


=head1 OPTIONS

  [ --project-path ] - optionally specify where to drop the project files. 

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
use Data::Dumper;

use Getopt::Long;

my $OPTIONS_VALUES = {};
my $OPTIONS=[
	'project-path=s',
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

our $TEMPLATE_CONFIG = {};


if ($OPTIONS_VALUES->{'auto-dev-mode'})
{
	$TEMPLATE_CONFIG->{INCLUDE_PATH} = "$RealBin/../templates";
	#print "HAR\n";
	print $TEMPLATE_CONFIG->{INCLUDE_PATH},$/;
	#exit;
}
else
{
	$TEMPLATE_CONFIG->{INCLUDE_PATH} = '/opt/IAS/templates/ias-package-shell';
	
}

my $package_info = {};

$package_info->{dater} = `date -R`;
chomp($package_info->{dater});

my $prompts = {
	name => {display => "Package name", required => 1},
	summary => {display => "Short summary", required => 1},
#	install_dir => {display => "Installation dir", required => 1},
	wiki_page => {display => "Wiki page",},
	ticket_url => {display => "Ticket URL",},
};

while (! defined $package_info->{name}
	|| $package_info->{name} =~ m/^\d/
	|| $package_info->{name} =~ m/\s+/
	|| $package_info->{name} =~ m/_/
)
{
	print "Package names must not begin with numbers.\n";
	print "Package names must not contain whitespace or underscores.\n";
	print "Example: some-package-name\n";
	get_stuff($package_info, $prompts, 'name');
}
# $prompts->{install_dir}->{default} = $default_install_dir.'/'.$package_info->{name};
get_stuff($package_info, $prompts, 'summary');

# get_stuff($package_info, $prompts, 'install_dir');
get_stuff($package_info, $prompts, 'wiki_page');
get_stuff($package_info, $prompts, 'ticket_url');

#print Dumper($package_info);
make_stuff($package_info);
exit;

sub get_stuff
{
	my ($hr, $prompts, $field) = @_;
	$hr->{$field} = prompt_and_get($prompts, $field);
	if ($prompts->{$field}->{required} && ! $hr->{$field})
	{
		print STDERR "$field is required.  exiting.",$/;
		exit;
	}
}

sub prompt_and_get
{
	my ($hr, $field) = @_;
	
	print "Required:",$/ if ($hr->{$field}->{required});
	print $hr->{$field}->{display},
		($hr->{$field}->{default} ? ' [' . $hr->{$field}->{default} .']' : '' ),": ";
	my $line = <STDIN>;
	chomp($line);
	$line ||= $hr->{$field}->{default};
	return $line;
}

sub write_template_file
{
	my ($output_file_name, $input_file_name, $template_hr) = @_;

	my $template = new Template($TEMPLATE_CONFIG)
		|| die "$Template::ERROR\n";

	my $output = '';
	$template->process($input_file_name,
		$template_hr,
		\$output,
	) or die $template->error();

	my $fh = new IO::File ">$output_file_name"
		or die "Can't open $output_file_name for writing: $!";
	
	print $fh $output;
	
	$fh->close();
}

sub make_stuff
{
	my ($package_info) = @_;
	use File::Path qw(make_path);
	use File::Copy;
	
	my $project_dir = $package_info->{name};
	$project_dir =~ s/-/_/g;
	
	if (defined $OPTIONS_VALUES->{'project-path'})
	{
		$project_dir = $OPTIONS_VALUES->{'project-path'}
	}		
	
	if (! -d $project_dir)
	{
		make_path($project_dir)
		or die "Cant mkdir: $package_info->{name} : $!";
	}
	
	chdir $project_dir
		or die "Couldn't chdir to $project_dir";
	
	write_template_file('.gitignore','gitignore',{ package => $package_info});
	write_template_file('Makefile', 'Makefile', { package => $package_info});
	write_template_file('README.md','README.md',{ package => $package_info});
	
	make_path('src')
		or die "Can't make src dir.";

	make_path('src/bin')
		or die "Can't make bin dir.";
	
	# make_path('src/etc')
	#	or die "Can't make etc dir.";

	make_path('run_scripts')
		or die "Can't make run_scripts dir.";
		
	make_path('tests')
		or die "Can't make tests path.";
	
	make_path('doc')
		or die "Can't make doc path.";
	write_template_file('doc/index.md','index.md',{ package => $package_info});
	
		
	
	# Project Directory / Package info directory	
	make_path($package_info->{name})
		or die "Can't make package info directory: $!";
	chdir $package_info->{name};
	write_template_file('changelog','changelog',{ package => $package_info});
	write_template_file('description','description',{ package => $package_info});
	write_template_file('rpm_specific','rpm_specific',{ package => $package_info});
	write_template_file('deb_control','deb_control', { package => $package_info});

	my $install_script_dir = $TEMPLATE_CONFIG->{INCLUDE_PATH}.'/'.'install_scripts';
	make_path('install_scripts');
		chdir('install_scripts');
		`cp $install_script_dir/* .`;
		chdir ('..');
}
