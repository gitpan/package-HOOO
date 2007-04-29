package package;
use strict;
use warnings;

our $VERSION = '0.0019';

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

sub alias {
	my $alias    = shift;
	my $original = shift;

	my $expression;

	$expression .= "package $alias;\n";
	$expression .= "use base '$original';\n";

	if (@_) {
		$expression .= "use strict;\n";
		$expression .= "use warnings;\n";
		foreach (@_) {
			if (/^([\$\@%&*])(.*)/) {
				$expression .= "\t*$2 = \\$1${original}::$2;\n";
			} else {
				$expression .= "\t*$_ = \\&${original}::$_;\n";
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

=head1 NAME

package - makes an alias of the current package

=head1 SYNOPSIS

	package ThisPAckage;
	
	sub new { }
	
	use package "Alias", qw'new';
	
	&Alias::new;
	
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

=head1 AUTHOR

Holger Seelig  holger.seelig@yahoo.de

=head1 COPYRIGHT

This is free software; you can redistribute it and/or modify it
under the same terms as L<Perl|perl> itself.

=cut

1;
__END__
