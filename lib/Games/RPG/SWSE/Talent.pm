package Games::RPG::SWSE::Talent;

=head1 NAME

Games::RPG::SWSE::Talent - An SWSE talent

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;

use Moose;
extends 'Games::RPG::SWSE::CharacterAspect';


=head1 ATTRIBUTES

Object attributes.

=cut


=head2 tree_id

=cut

has 'tree_id' =>
(
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);


no Moose; __PACKAGE__->meta->make_immutable;

=head1 METHODS

Methods called on an instantiated object.

=cut

1;

__END__

=head1 SEE ALSO

=over

=item * L<Something> - Does something

=back

=head1 AUTHOR

Ron "Quinn" Straight E<lt>quinnfazigu@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Public domain.  Free to use and distribute, attribution appreciated.

=cut



