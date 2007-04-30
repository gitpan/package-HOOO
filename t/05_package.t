#!/usr/bin/perl -w
#package 05_package
use Test::More tests => 7;
use strict;

BEGIN {
	$| = 1;
	chdir 't' if -d 't';
	unshift @INC, '../lib';
	use_ok 'package';
}

package Original;

our $Var = 2;
our @it = ( 1, 2, 3 );
our %Hash = ( 'a', 2, 'b', 'fg' );

sub sub { bless {}, $_[0] }
sub function { bless {}, $_[0] }

sub routine { pop }
sub ggg { pop }

package main;

package::alias('Alias', 'Original', [{'@as' => '@it', '@like' => '@it'}, qw'sub function'], 'routine', ['ggg']);

ok defined @Alias::as;
is ((join ' ', @Alias::as), '1 2 3');
is ((join ' ', @Alias::as), '1 2 3');
is ref Alias->sub, 'Alias';
is ref Alias->function('Alias'), 'Alias';

is routine Alias (123), '123';

__END__
