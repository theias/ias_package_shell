#!/usr/bin/perl

# $Id$
=pod

=head1 NAME

package_shell.pl - Creates a project directory that generates an installable package

=head1 SYNOPSIS

  package_shell.pl

=head1 DESCRIPTION

A set of libraries and packaging routines have been set up to automate the process
of creating projects and installing them.  This creates the base project
directories.

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

my $project_info = {};

$project_info->{dater} = `date -R`;
chomp($project_info->{dater});

my $prompts = {
	project_name => {display => "Project name", required => 1},
	summary => {display => "Short summary", required => 1},
#	install_dir => {display => "Installation dir", required => 1},
	wiki_page => {display => "Wiki page",},
	ticket_url => {display => "Ticket URL",},
};

while (! defined $project_info->{project_name}
	|| $project_info->{project_name} =~ m/^\d/
	|| $project_info->{project_name} =~ m/\s+/
	|| $project_info->{project_name} =~ m/-/
)
{
	print "Project names must not begin with numbers.\n";
	print "Project names must not contain whitespace or dashes.\n";
	print "Example: some_project_name\n";
	get_stuff($project_info, $prompts, 'project_name');
}

my @project_name_parts = split('_', $project_info->{project_name});
$project_info->{aspell_name_parts} = join("\n", @project_name_parts);

get_stuff($project_info, $prompts, 'summary');

get_stuff($project_info, $prompts, 'wiki_page');
get_stuff($project_info, $prompts, 'ticket_url');

make_stuff($project_info);
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
	my ($project_info) = @_;
	use File::Path qw(make_path);
	use File::Copy;
	
	# This all needs to be redone in a more consistent way
	
	my $project_dir = $project_info->{project_name};
	
	$project_info->{package_name} = $project_info->{project_name};
	$project_info->{package_name} =~ s/_/-/g;
	
	if (defined $OPTIONS_VALUES->{'project-path'})
	{
		$project_dir = $OPTIONS_VALUES->{'project-path'}
	}		
	
	if (! -d $project_dir)
	{
		make_path($project_dir)
		or die "Cant mkdir: $project_info->{project_name} : $!";
	}
	
	chdir $project_dir
		or die "Couldn't chdir to $project_dir";
	
	write_template_file('.gitignore','gitignore',{ project => $project_info});
	write_template_file('Makefile', 'Makefile', { project => $project_info});
	write_template_file('README.md','README.md',{ project => $project_info});
	
	# spell checking
	write_template_file('spell_check.sh','spell_check.sh',{ project => $project_info});
	chmod 0755, 'spell_check.sh';
	write_template_file('aspell_project.pws','aspell_project.pws',{ project => $project_info});
	
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
	write_template_file('doc/index.md','index.md',{ project => $project_info});
	
		
	
	# Project Directory / Package info directory	
	make_path($project_info->{package_name})
		or die "Can't make package info directory: $!";

	use Data::Dumper;
	print Dumper($project_info),$/;

	chdir $project_info->{package_name};
	write_template_file('changelog','changelog',{ project => $project_info});
	write_template_file('description','description',{ project => $project_info});
	write_template_file('rpm_specific','rpm_specific',{ project => $project_info});
	write_template_file('deb_control','deb_control', { project => $project_info});

	my $install_script_dir = $TEMPLATE_CONFIG->{INCLUDE_PATH}.'/'.'install_scripts';
	make_path('install_scripts');
		chdir('install_scripts');
		`cp $install_script_dir/* .`;
		chdir ('..');
	

	
	my $package_shell_dir = $TEMPLATE_CONFIG->{INCLUDE_PATH}.'/'.'package_shell';
	make_path('package_shell');
		chdir('package_shell');
		`cp -r $package_shell_dir/* .`;
		chdir ('..');
	
	
}
