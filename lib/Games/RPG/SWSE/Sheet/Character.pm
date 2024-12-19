package Games::RPG::SWSE::Sheet::Character;

=head1 NAME

Games::RPG::SWSE::Sheet::Character - Gameplay aid for a specific character

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Moose;
extends qw( Games::RPG::SWSE::Sheet );

=head1 ATTRIBUTES

Object attributes.

=cut

has 'character' => (
	'is'         => 'rw',
	'isa'        => 'Games::RPG::SWSE::Character',
	'required'   => 1,
);

no Moose; __PACKAGE__->meta->make_immutable;

=head1 METHODS

Methods called on an instantiated object.

=cut

1;

__END__

=head1 SEE ALSO

=over

=item * L<Games::RPG::SWSE::Sheet> - Base gameplay aid class

=back

=head1 AUTHOR

Ron "Quinn" Straight E<lt>quinnfazigu@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Public domain.  Free to use and distribute, attribution appreciated.

=cut

