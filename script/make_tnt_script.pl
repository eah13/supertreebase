#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use List::Util 'sum';

# process command line arguments
my ( $ncharfile, $speciesfile );
GetOptions(
	'ncharfile=s'   => \$ncharfile,
	'speciesfile=s' => \$speciesfile,
);

# compute number of overall characters
my $nchar;
{
	my %nchars;
	open my $fh, '<', $ncharfile or die $!;
	while(<$fh>) {
		chomp;
		my @line = split /\t/, $_;
		$nchars{$line[0]} = $line[1];
	}
	close $fh;
	$nchar = sum(values %nchars);
}

# compute number of overall taxa
my $ntax;
{
	my %ntax;
	open my $fh, '<', $speciesfile or die $!;
	while(<$fh>) {
		chomp;
		my @line = split /\t/, $_;
		my @taxa = split /,/, $line[1];
		$ntax{$_} = 1 for @taxa;
	}
	close $fh;
	$ntax = scalar(keys %ntax);
}

print <<"HERE";
macro=;
nstates 2;
xread 
$nchar $ntax
HERE
