#!/usr/bin/perl

use strict;
use warnings;

package IAS::TemplateMenuingSystem;

use IO::File;
use IO::Dir;
use Data::Dumper;
use JSON;

# perl-IO-Prompter.noarch
# libio-prompter-perl

our $TEMPLATE_PATHS = $ENV{'TEMPLATE_PATHS'} 
	// "/opt/IAS/templates";


sub new
{
	my $type = shift;
	my $self = {};
	return bless $self, $type;
}

sub run
{
	my ($self) = @_;

	$self->load_template_data();

}

sub load_template_data
{
	my ($self) = @_;

	my $template_data = {};
	print "here\n";
	my @template_paths = split(':', $TEMPLATE_PATHS);

	my $template_path_data = {};
	load_base_template_path: foreach my $template_path (@template_paths)
	{
		my $dir = IO::Dir->new($template_path);
		if (! $dir )
		{
			warn "Unable to open template path $template_path : $!\n";
			next load_base_template_path;
		}

		my $package_templates = {};
		my $dir_entry;
		package_template_dir_entry: while (defined($dir_entry = $dir->read()))
		{
			next package_template_dir_entry
				if ($dir_entry eq '.' || $dir_entry eq '..' );

			my $package_path = join('/', $template_path, $dir_entry);
			$package_templates->{$dir_entry} = $self->load_templates_from_package(
				$package_path,
			);
		}

		$template_path_data->{$template_path} = $package_templates;

		print Dumper($template_path_data),$/;
	}

}

sub load_templates_from_package
{
	my ($self, $package_path) = @_;

	my $dir = new IO::Dir($package_path);

	my $dir_hash;
	my $dir_entry;
	package_dir_entry: while (defined($dir_entry = $dir->read()))
	{
		next package_dir_entry
			if ($dir_entry eq '.' || $dir_entry eq '..');

		$dir_hash->{$dir_entry} = {};


	}
}

package main;

my $program = IAS::TemplateMenuingSystem->new();

$program->run();

exit;
