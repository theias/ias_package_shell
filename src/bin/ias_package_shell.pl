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

use Getopt::Long;
my $DEBUG=0;
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
our $PROJECT_TEMPLATE_DIR;

our $TEMPLATE_CONFIG = {};


if ($OPTIONS_VALUES->{'auto-dev-mode'})
{
	$PROJECT_TEMPLATE_DIR="$RealBin/../templates/project_dir";
	# $TEMPLATE_CONFIG->{INCLUDE_PATH} = "$RealBin/../templates";
	#print "HAR\n";
	# print $TEMPLATE_CONFIG->{INCLUDE_PATH},$/;
	#exit;
}
else
{
	$PROJECT_TEMPLATE_DIR="/opt/IAS/templates/ias-package-shell/project_dir";
	# $TEMPLATE_CONFIG->{INCLUDE_PATH} = '/opt/IAS/templates/ias-package-shell';
	
}


my $prompts = {
	project_name => {display => "Project name", required => 1},
	summary => {display => "Short summary", required => 1},
#	install_dir => {display => "Installation dir", required => 1},
	wiki_page => {display => "Wiki page",},
	ticket_url => {display => "Ticket URL",},
};

my $project_info = get_project_info($prompts);

$project_info->{BASE_DIR} ||= '/opt/IAS';
$project_info->{AUTOMATION_USER} ||= 'iasnetauto';
$project_info->{AUTOMATION_GROUP} ||= 'iasnetauto';
$project_info->{USE_AUTOMATION_PERMISSIONS} ||= 0;
$project_info->{installed_directory_layout} ||= 'project_directories-full_project.gmk';


process_project_dir($project_info);
exit;


sub get_project_info
{
	my ($prompts) = @_;
	
	my $project_info = {};

	$project_info->{dater} = `date -R`;
	chomp($project_info->{dater});

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

	$project_info->{package_name} = $project_info->{project_name};
	$project_info->{package_name} =~ s/_/-/g;
	return $project_info;
}

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
	if (defined $OPTIONS_VALUES->{'project-path'})
	{
		$project_dir = $OPTIONS_VALUES->{'project-path'}
	}

	rcopy($PROJECT_TEMPLATE_DIR, $project_dir)
		or die ("Unable to rcopy $PROJECT_TEMPLATE_DIR to $project_dir: $!");

	finddepth(
		{
			wanted => sub { rename_path_template($_, { project => $project_info}); },
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
