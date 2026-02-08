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

}

sub load_template_data
{
	my ($self) = @_;

	my $template_data = {};

	my @template_paths = split(':', $TEMPLATE_PATHS);

	load_template_path: foreach my $template_path (@template_paths)
	{
		tie %dir, 'IO::Dir', $template_path;

		my $info = {
			'base_template_path' => $template_path,
			'package' => $
	}

}

package main;

my $program = IAS::TemplateMenuingSystem->new();

$program->run();

exit;
