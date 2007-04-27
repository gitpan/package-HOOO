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

package ThisPAckage;

sub new { }

use package "Alias", qw'new';

&Alias::new;

__END__
