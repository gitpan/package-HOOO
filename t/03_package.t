#!/usr/bin/perl -w
#package 03_package
use Test::More tests => 9;
use strict;

BEGIN {
	$| = 1;
	chdir 't' if -d 't';
	unshift @INC, '../lib';
	use_ok 'package';
}

package Original;

our $Var = 2;
our @Ar = ( 1, 2, 3 );
our %Hash = ( 'a', 2, 'b', 'fg' );

sub new { bless {}, $_[0] }

sub sub_from_original { }

package main;

package::alias( 'Alias', 'Original', qw'$Var &new @Ar %Hash' );

my $alias = new Alias();
$alias->sub_from_original;

is $Alias::Var, '2';
is $Alias::Var, '2';
is $Original::Var = 3, '3';
is $Alias::Var, '3';
is @Alias::Ar, '3';
is @Alias::Ar, '3';
is $Alias::Hash{b}, 'fg';
is $Alias::Hash{a}, '2';

__END__
