#!/usr/bin/perl

use strict;
use warnings;

package IAS::PackageShell::MultipleArtifactTest;

sub hello_world
{
	return "Hello, world!\nFrom: ".__PACKAGE__."\n";
}

1;
