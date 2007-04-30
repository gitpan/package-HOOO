#!/usr/bin/perl -w
#package 04_package
use Test::More tests => 14;
use strict;

BEGIN {
	$| = 1;
	chdir 't' if -d 't';
	unshift @INC, '../lib';
	use_ok 'package';
}

package Original;

our $Var  = 2;
our @Ar   = ( 1, 2, 3 );
our %Hash = ( 'a', 2, 'b', 'fg' );

sub make { bless {}, $_[0] }

sub sub_from_original { pop }

package main;

package::alias( 'Alias', 'Original', qw'$Var %Hash', {
		'@Array' => '@Ar',
		'new'    => 'make',
		'alias'  => 'make',
} );

ok ref alias Alias(), 'Alias';
ok my $alias = new Alias();
isa_ok $alias, 'Alias';
isa_ok $alias, 'Original';
is $alias->sub_from_original(123), 123;

is $Alias::Var, '2';
is $Alias::Var, '2';
is $Original::Var = 3, '3';
is $Alias::Var, '3';
is @Alias::Array, '3';
is @Alias::Array, '3';
is $Alias::Hash{b}, 'fg';
is $Alias::Hash{a}, '2';

__END__
