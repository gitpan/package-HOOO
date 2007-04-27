package package;
use strict;
use warnings;

our $VERSION = '0.0002';

#printf "*** %s VERSION: %s\n", __PACKAGE__, $VERSION;

my $import = q|
	package %s;
	use base "%s";
	*VERSION = \$%s::VERSION if defined $%s::VERSION;
|;

sub import {
	shift;
	return unless @_;
	my $original = caller;
	package::use( $original, @_ );
}

sub use {
	my $original = shift;
	my $alias    = shift;

	my $expression = sprintf $import, $alias, $original, $original, $original;

	$expression .= "\t*$_ = \\&${original}::$_;\n" foreach @_;

	eval $expression;
	if ($@) {
		printf "%s\n", $expression;
		warn $@;
	}
	
}

=head1 NAME

package - makes an alias of the current package

=head1 SYNOPSIS

	package ThisPAckage;
	
	sub mysub { 1 };
	sub as { 0 };
	
	use package "asNewName", qw'mysub as';
	
	&asNewName::mysub;
	&asNewName::as;
	
	or
	
	package main;
	
	my $original = __PACKAGE__;
	my $alias = "MyPackage";
	package::use($original, $alias);
	
	$alias->mysub;
	$alias->as;
	
	MyPackage->mysub;
	MyPackage->as;

=head1 DESCRIPTION

use package makes an alias of the current package
and establishs IS-A relationship with current package and alias at compile time 

=head1 METHODS

=head2 use($original, $alias, @import)

use package makes as alias of the original
and imports the symbols in import in the namespace of alias

	package::use($original, $alias, qw'importnames basename dirname');

=head1 AUTHOR

Holger Seelig  holger.seelig@yahoo.de

=head1 COPYRIGHT

This is free software; you can redistribute it and/or modify it
under the same terms as L<Perl|perl> itself.

=cut

1;
__END__
