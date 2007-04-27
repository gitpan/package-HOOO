#!/usr/bin/perl -w
#package 01_package
use Test::More tests => 11;
use strict;

BEGIN {
	$| = 1;
	chdir 't' if -d 't';
	unshift @INC, '../lib';
	use_ok 'package';
}

sub mysub { 1 };
sub as { 0 };

use package "alias", qw'mysub as';
ok &alias::mysub;
ok ! &alias::as;

ok 'alias'->mysub;
ok ! 'alias'->as;

ok (alias->mysub);
ok (! alias->as);

my $original = __PACKAGE__;
my $alias = "MyPackage";
package::use($original, $alias);

ok $alias->mysub;
ok ! $alias->as;

ok (MyPackage->mysub);
ok (! MyPackage->as);


__END__
