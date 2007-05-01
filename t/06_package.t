#!/usr/bin/perl -w
#package 06_package
use Test::More tests => 24;
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

sub sub_from_original { 123 }

package main;

ok Alias->package::base( 'Original', [qw'$Var &new'], qw'@Ar %Hash new', {'create' => 'new'} );
ok my $alias = new Alias();
#can_ok 'Original', 'make';

'Original'->package::import('Alias', {'make' => 'new'} );

is \&Original::new, \&Original::make;
is \&Alias::create, \&Original::make;
is \&Alias::new, \&Original::make;

ok $alias = new Alias();
can_ok $alias, 'make';
can_ok $alias, 'new';
ok $alias = make Original();
can_ok $alias, 'new';
can_ok $alias, 'make';
can_ok 'Alias', 'make';
can_ok 'Alias', 'create';
can_ok 'Original', 'make';
is $alias->sub_from_original, '123';

is $Alias::Var, '2';
is $Alias::Var, '2';
is $Original::Var = 3, '3';
is $Alias::Var, '3';
is @Alias::Ar, '3';
is @Alias::Ar, '3';
is $Alias::Hash{b}, 'fg';
is $Alias::Hash{a}, '2';

__END__
