#!/usr/bin/perl -w
#package 03_package
use Test::More tests => 1;
use strict;

BEGIN {
	$| = 1;
	chdir 't' if -d 't';
	unshift @INC, '../lib';
	use_ok 'package';
}

package Original;

sub new { bless {}, $_[0] }

sub sub_from_original { }

package main;

package::alias( 'Alias', 'Original' );

my $alias = new Alias();
$alias->sub_from_original;

__END__
