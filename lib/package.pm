package package;
use strict;
use warnings;

our $VERSION = '0.0031';

use Carp 'carp';
#printf "*** %s VERSION: %s\n", __PACKAGE__, $VERSION;

#	*VERSION = \$%s::VERSION if defined $%s::VERSION;

sub import {
	shift;
	return unless @_;
	my $alias    = shift;
	my $original = caller;
	package::alias( $alias, $original, @_ );
}

our $_space = qr/\s+/so;
our $_type  = qr/^([\$\@%&*]?)(.*)/so;

sub alias {
	my $alias    = shift;
	my $original = shift;

	my $expression;

	$expression .= "package $alias;\n";
	$expression .= "use base '$original';\n";

	if (@_) {
		$expression .= "use strict;\n";
		$expression .= "use warnings;\n";

		if (@_) {
			foreach (@_) {

				if ( 'HASH' eq ref $_ ) {

					while ( my ( $a, $o ) = each %$_ ) {
						if ( $a =~ m.$_type.gc && $1 ) {
							my $t = $1;
							$a = $2;
							if ( $o =~ m.$_type.gc ) {
								$t = $1 if $1;
								$expression .= atpo( $a, $t, $original, $2 );
							} else {
								carp "Syntax error";
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

		}
	}

	eval $expression;
	if ($@) {
		#printf "%s\n", $expression;
		#carp $@;
		carp "Syntax error";
	}

}

sub atpo { sprintf "\t*%s = \\%s%s::%s;\n", @_ }

=head1 NAME

package - makes an alias of the current package

=head1 SYNOPSIS

	package ThisPAckage;
	
	sub new { }
	
	use package "Alias", qw'new', { alias => 'new' };
	
	my $ref = &Alias::new;
	my $obj = Alias->alias;
	
	or
	
	package main;
	
	package::alias('Alias', 'Original');
	
	my $alias = new Alias();
	$alias->sub_from_original;

=head1 DESCRIPTION

use package makes an alias of the current package
and establishs IS-A relationship with current package and alias at compile time 

=head1 METHODS

=head2 alias($alias, $original, @import)

use package makes as alias of the original
and imports the symbols in import in the namespace of alias

	package::alias($alias, $original, qw'$var $foo basename');
	package::alias($alias, $original, {'@as => '@it', '@like => '@it'}, qw'sub routine');

=head1 AUTHOR

Holger Seelig  holger.seelig@yahoo.de

=head1 COPYRIGHT

This is free software; you can redistribute it and/or modify it
under the same terms as L<Perl|perl> itself.

=cut

1;
__END__
