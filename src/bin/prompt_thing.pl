#!/usr/bin/perl

use strict;
use warnings;

use JSON;
use IO::File;

use Getopt::Long;
use Data::Dumper;

my $file_name = $ARGV[0]
	or die "First arg is json file.\n";

print Dumper(do_prompts(load_json_file($ARGV[0])));

exit;

sub do_prompts
{
	my ($structure) = @_;
	
	my $prompts = $structure->{prompts};
	
	my $data = {};
	THIS_PROMPT: foreach my $prompt (@$prompts)
	{
		if ($prompt->{'description'})
		{
			print $prompt->{"description"},$/
		}
		
		print $prompt->{"prompt"};
		my $response = <STDIN>;
		chomp($response);
		my $fail_regex = $prompt->{'fail_regex'};
		
		if ( $fail_regex && $response =~ m/$fail_regex/)
		{
			print "$response matches fail regex: $fail_regex.  Please try again.\n";
			redo THIS_PROMPT;
		}
		
		my $pass_regex = $prompt->{'pass_regex'};
		if ($pass_regex && $response !~ m/$pass_regex/)
		{
			print "$response does not match pass regex: $pass_regex.  Please try again.\n";
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
