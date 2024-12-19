package Games::RPG::SWSE::WeaponThrown;

=head1 NAME

Games::RPG::SWSE::WeaponThrown - An SWSE ranged weapon

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;

use Games::RPG::SWSE::TypeConstraints;

## use Moose::Util::TypeConstraints;
## enum 'SwseWeaponFireRate'    => qw( Single Auto );

use Moose;
extends qw( Games::RPG::SWSE::WeaponRanged );

sub _build_weapon_group   { 'Thrown' }
sub _build_usage_stat_id  { 'BABMelee' }

no Moose; __PACKAGE__->meta->make_immutable;

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




