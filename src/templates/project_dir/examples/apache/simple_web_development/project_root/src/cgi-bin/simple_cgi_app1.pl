#!/usr/bin/perl

=pod

=head1 NAME

simple_cgi_app1.pl

=head1 DESCRIPTION

A _very_ rough example of a cgi-bin program that is capable of
automatically resolving project paths.

=head1 NOTE

The IAS::Infra libraries weren't developed from the point of
view of shared memory environments, such as mod-perl.  I started
to work on that, but then came to the conclusion that if you
do intend on using shared memory environments, you're probably
going to be well aware of how stuff should work anyway.

=cut

use strict;
use warnings;

use lib '/opt/IAS/lib/perl5';

package IAS::Network::Apps::SimpleCGIExample1;

use strict;
use warnings;

use base 'IAS::Infra::FullProjectPaths';

use CGI;

sub new
{
	my $type = shift;
	my $self = {};
	return bless $self, $type;
}

sub run
{
	my ($self) = @_;
	$self->setup();

	print $self->{cgi}->header(),$/;

	print "Hello.<br>\n";

	$self->debug_paths();

}

sub log_debug
{
	my ($self) = shift;
	print @_,$/;
}

sub setup
{
	my ($self) = @_;

	$self->{cgi} = CGI->new();
}

package main;

my $app = IAS::Network::Apps::SimpleCGIExample1->new();
$app->run();

exit;

