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

=over 4

=item [ --project-path-output ] - optionally specify where to drop the project files.
The default is the current directory.

=item [ --project-control-file ] - A JSON file that contains configuration for
the project.

=item [ --project-template-dir ] - The directory containing the project template.
It defaults to the project-control-file name, without the '.json' extension.

=item [ --do-post-create-run ] - Run the "post-create-run" entry from the control
file.  Disable with --nodo-post-create-run

=back

=cut


use strict;
use warnings;

use lib '/opt/IAS/lib/perl5';

use FindBin qw($RealBin);
use lib "$RealBin/../lib/perl5";

use IAS::PackageShell;
my $package_shell = IAS::PackageShell->new();

$package_shell->run();

exit;


