package package;
use strict;
use warnings;

our $VERSION = '0.0037';

use Carp 'croak';
#printf "*** %s VERSION: %s\n", __PACKAGE__, $VERSION;

#	*VERSION = \$%s::VERSION if defined $%s::VERSION;

#'Original'->package::import('Alias', {'make' => 'new'} );

sub import {
	my $to = shift;

	return unless @_;

	my $alias = shift;
	my $original = caller;

	if ( $to eq __PACKAGE__ ) {
		my $original = caller;
		package::alias( $alias, $original, @_ );
	} else {
		package::_import( $to, $alias, @_ );
	}
}

our $_space = qr/\s+/so;
our $_type  = qr/^([\$\@%&*]?)(.*)/so;

sub alias {
	my $alias    = shift;
	my $original = shift;

	my $expression;

	eval package::expression( $alias, $original, @_ );

	if ($@) {
		#printf "%s\n", $expression;
		#croak $@;
		croak "Syntax error";
	}

	return 1;
}

*base = \&alias;

sub expression {
	my $alias    = shift;
	my $original = shift;

	my $expression;

	$expression .= "package $alias;\n";
	$expression .= "use base '$original';\n";

	if (@_) {
		$expression .= "use strict;\n";
		$expression .= "use warnings;\n";

		$expression .= package::statements( $alias, $original, @_ );
	}

	return $expression;
}

sub _import {
	my $alias    = shift;
	my $original = shift;

	my $expression;

	$expression .= "package $alias;\n";

	if (@_) {
		$expression .= "use strict;\n";
		$expression .= "use warnings;\n";

		$expression .= package::statements( $alias, $original, @_ );
	}

	return eval $expression;
}

sub statements {
	my $alias    = shift;
	my $original = shift;

	my $expression;

	return '' unless @_;

	foreach (@_) {

		if ( 'ARRAY' eq ref $_ ) {

			$expression .= package::statements( $alias, $original, @$_ );

		} elsif ( 'HASH' eq ref $_ ) {
			while ( my ( $a, $o ) = each %$_ ) {
				if ( $a =~ m.$_type.gc && $1 ) {
					my $t = $1;
					$a = $2;
					if ( $o =~ m.$_type.gc ) {
						$t = $1 if $1;
						$expression .= atpo( $a, $t, $original, $2 );
					} else {
						croak "Syntax error";
					}
				} else {
					$expression .= atpo( $a, '&', $original, $o );
				}
			}
		} else {
			foreach ( split /$_space/, $_ ) {
				if ( m.$_type.gc && $1 ) {
					$expression .= atpo( $2, $1, $original, $2 );
				} else {
					$expression .= atpo( $_, '&', $original, $_ );
				}
			}
		}
	}

	return $expression;
}

sub atpo {
	my ( $alias, $type, $package, $original ) = @_;
	#croak  sprintf "\t*%s = \\%s;\n", ( $alias, $original ) if $original =~ /::/so;
	return sprintf "\t*%s = \\%s;\n", ( $alias, $original ) if $original =~ /::/so;
	return sprintf "\t*%s = \\%s%s::%s;\n", ( $alias, $type, $package, $original );
}

=head1 NAME

package - makes an alias of the current package

=head1 SYNOPSIS

	
	package ThisPAckage;
	
	sub new { }
	
	use package "Alias", qw'new', { alias => 'new' };
	ThisPAckage->package::import("Time::HiRes", 'time'};
	
	my $ref = &Alias::new;
	my $obj = Alias->alias;
	
	or
	
	package main;
	
	Alias->package::base('Original');
	
	my $alias = new Alias();
	$alias->sub_from_original;

=head1 DESCRIPTION

use package makes an alias of the current package
and establishs IS-A relationship with current package and alias at compile time 

=head1 METHODS

=head2 base($alias, $original, ...)

use package makes as alias of the original
and imports the symbols in import in the namespace of alias

	package::base($alias, $original, qw'$var $foo basename');
	
	package::base($alias, $original, [{'@as' => '@it', '@like' => '@it'}, qw'sub function'], 'routine', ['ggg'];


=head2 import($to, $from, ...)

imports the symbols from $from to $to

	Foo->package::import('from', {'foo' => 'new'} );

=head1 AUTHOR

Holger Seelig  holger.seelig@yahoo.de

=head1 COPYRIGHT

This is free software; you can redistribute it and/or modify it
under the same terms as L<Perl|perl> itself.

=cut

1;
__END__
