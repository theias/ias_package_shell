#!/usr/bin/perl

use strict;
use warnings;

use IO::Dir;
use IO::File;
use Data::Dumper;

our (@DIRS);
our (@FILES);

use Getopt::Long;

my (@IGNORE_REGEXES);
my ($no_fakeroot);
GetOptions(
	'ignore-regex=s' => \@IGNORE_REGEXES,
	'no-fakeroot' => \$no_fakeroot,
);
my $search_dir = $ARGV[0];

if (!$search_dir)
{
	die "Give a dir...";
}

traverse_dir($search_dir);

#print "%files\n";

if (scalar(@DIRS))
{
	my $dir;
	foreach $dir (@DIRS)
	{
		my $inst_dir = $dir;
		$inst_dir =~ s/\Q$search_dir\E//;
		 
		print "%dir $inst_dir",$/;
	}
}
if (scalar(@FILES))
{
	process_array_entry($search_dir, $_)
		foreach (@FILES);
}

exit;

sub process_array_entry
{
	my ($search_dir, $array_entry) =@_;
	my $inst_array_entry = $array_entry;
	$inst_array_entry =~ s/\Q$search_dir\E//;
	if ($no_fakeroot)
	{
		print $inst_array_entry,$/;
	}
	else
	{
		print_rpm_file_attrs($array_entry, $inst_array_entry);
	}
}

sub traverse_dir
{
	my ($dir_name) = @_;
	
	if (! -d $dir_name)
	{
		die "$dir_name isn't a directory";
	}

	my $count = 0;
	
	my $dir_h = new IO::Dir "$dir_name"
		or die "Can't open $dir_name for reading: $!";
	
	# print "Dir name: $dir_name\n";
	
	my $thing;
	while (defined($thing = $dir_h->read()))
	{
		my $current_thing = join('/', $dir_name, $thing);
		# print "Thing: $current_thing\n";
		if (-f $current_thing)
		{
			add_to_array_unless_ignored(
				\@IGNORE_REGEXES,
				\@FILES,
				$current_thing
			);
			$count++;
		}
		elsif (-d $current_thing &&
			$thing ne '..' &&
			$thing ne '.'
		)
		{
			traverse_dir($current_thing);
			$count++;
		}
		
	}
	
	if (! $count)
	{
		add_to_array_unless_ignored(
			\@IGNORE_REGEXES,
			\@DIRS,
			$dir_name
		);
	}
	
	$dir_h->close();
}

sub add_to_array_unless_ignored
{
	my ($ignore_regexes, $array, $current) = @_;
	
	return
		if (scalar(grep{$current =~ m/\Q$_\E/} @$ignore_regexes));
	push @$array, $current;
}


sub print_rpm_file_attrs
{
	use Fcntl ':mode';
	my ($file_name, $inst_path) = @_;
	my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
		$atime,$mtime,$ctime,$blksize,$blocks)
	= stat($file_name);
	#printf "Permissions are %04o\n", S_IMODE($mode), "\n";
	my $traditional_mode = sprintf('%04o',S_IMODE($mode));
	$traditional_mode =~ s/^0//;
	my $pwuid = (getpwuid($uid))[0];
	my $grgid = (getgrgid($gid))[0];
	print"%attr($traditional_mode, $pwuid, $grgid) $inst_path",$/;
}
