#!/usr/bin/perl

use strict;
use warnings;

package IAS::TemplateMenuingSystem;

use IO::File;
use IO::Dir;
use File::Basename qw(dirname basename);
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
	my @template_paths = split(':', $TEMPLATE_PATHS);

	load_base_template_path: foreach my $template_path (@template_paths)
	{
		if (! -d "$template_path" )
		{
			warn "$template_path is not a directory...";
			next load_base_template_path;
		}

		# print "Template path: $template_path\n";

		my $template_path_parent = dirname($template_path);
		my $template_path_parent_basename = basename($template_path_parent);
		# print "Template path parent: $template_path_parent\n";
		if ($template_path_parent_basename eq 'src')
		{
			# print "It's in src.\n";
			my $template_container = basename(dirname($template_path_parent));
			
			my $params = {
				'template_container' => $template_container,
				'template_container_path' => $template_path,
			};

			$self->load_templates_from_template_container($params);

			next load_base_template_path;
		}

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

			my $template_container = $dir_entry;
			my $template_container_path = join('/', $template_path, $dir_entry);

			my $params = {
				'template_container' => $template_container,
				'template_container_path' => $template_container_path,
			};

			$self->load_templates_from_template_container($params);
		}


		# print Dumper($template_path_data),$/;
	}

}

sub load_templates_from_template_container
{
	my ($self, $params) = @_;

	print Dumper($params),$/;
	return;
	my $dir = new IO::Dir($params->{'template_container_path'});

	my $dir_hash;
	my $dir_entry;
	package_dir_entry: while (defined($dir_entry = $dir->read()))
	{
		next package_dir_entry
			if ($dir_entry eq '.' || $dir_entry eq '..');


	}
}

package main;

my $program = IAS::TemplateMenuingSystem->new();

$program->run();

exit;
