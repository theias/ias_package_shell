#!/usr/bin/perl

use strict;
use warnings;

use lib '/opt/IAS/lib/perl5';

use FindBin qw($RealBin);
use lib "$RealBin/../lib/perl5";

use IAS::PackageShell::MultipleArtifactTest;

print IAS::PackageShell::MultipleArtifactTest::hello_world();


