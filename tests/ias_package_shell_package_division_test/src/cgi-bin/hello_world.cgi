#!/usr/bin/perl

use strict;
use warnings;

### CGI-Bin Infrastructure

###################################
# This hopefully is both cgi script compatible
# and mod_perl compatible
use Cwd;
use File::Basename;
my $RealPath;
BEGIN {
	
	$RealPath = Cwd::realpath(__FILE__);
}

use lib '/opt/IAS/lib/perl5';
use lib dirname($RealPath).'/../lib/perl5';

my $app = new IAS::PackageShell::MultipleArtifactTest::CGITest;

$app->run();

exit;


### End CGI-Bin Infrastructure

package IAS::PackageShell::MultipleArtifactTest::CGITest;

use CGI;
# use CGI::Carp qw(fatalsToBrowser);

use IAS::PackageShell::MultipleArtifactTest;

use Data::Dumper;

sub new
{
	my ($type, $self) = shift;
	$self ||= {};
	return bless $self, $type;
}

sub run
{
	my ($self) = @_;
	
	my $cgi = CGI->new();
	
	print $cgi->header();
	
	print "<html><body><pre>Hello.\n";
	print IAS::PackageShell::MultipleArtifactTest::hello_world();
	print "</pre></body></html>\n";
}

exit;

