package Games::RPG::SWSE::WeaponUnarmed;

=head1 NAME

Games::RPG::SWSE::WeaponUnarmed - An SWSE unarmed attack

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;

use Moose;
extends qw( Games::RPG::SWSE::WeaponMelee );

=head1 ATTRIBUTES

Object attributes.

=cut

sub _build_usage_stat_id         { 'BABMelee'          }
sub _build_damage_bonus_stat_id  { 'AbilitySTR'        }
sub _build_size                  { 'Small'             }
sub _build_cost                  {  0                  }
sub _build_weight                {  0                  }
sub _build_availability          { 'Unrestricted'      }
sub _build_weapon_group          { 'Simple'            }
sub _build_damage_type           { [qw( Bludgeoning )] }

## sub _build_base_kill_damage_dice { [qw( 1d4 )]         }
## sub _build_base_stun_damage_dice { [qw( 1d4 )]         }

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_base_any_damage_dice
{
	my $self = shift;
	my $char = $self->character;
	my $size = $char->size_class;

	my @base;

	## According to CORE163, medium characters deal 1d4
	## and small 1d3.  No others are mentioned.  I'm
	## just gonna extrapolate here.
	push(@base, sprintf('d%d', $size)) if $size;

	## And now for the fucking hacks.  Grr.
	foreach my $ii ( 1 .. 3 ) {
		push(@base, 'd++') if $char->feat('MartialArts' . 'I' x $ii);
	}

	return \@base;
}

## According to http://swse.xphilesrealm.com/Jedi%20Counseling/Jedi%20Counseling%20112.pdf,
## unarmed IS a light weapon.
sub _build_is_light_weapon { 1 }

sub _build_base_stun_damage_dice { shift->_build_base_any_damage_dice }
sub _build_base_kill_damage_dice { shift->_build_base_any_damage_dice }

=head1 METHODS

Methods called on an instantiated object.

=cut

sub combat_stats
{
	my $self      = shift;
	my $character = $self->character;

	my $am_name     = $self->name;
	my $am_bab      = $self->base_attack_bonus;
	my $am_dmg_type = join('/', @{ $self->damage_type });

	my $half_level_bonus       = $self->heroic_level_damage_dice;
	my $single_str_bonus       = $self->single_strength_damage_dice;
	my @base_kill_dmg_dice     = @{ $self->base_kill_damage_dice || [] };
	my @base_stun_dmg_dice     = @{ $self->base_stun_damage_dice || [] };
	my @unarmed_kill_dmg_dice  = ( @base_kill_dmg_dice, $half_level_bonus, $single_str_bonus );

	my $base_kill_dmg_dice_desc = $self->describe_dice(@base_kill_dmg_dice);
	my $base_stun_dmg_dice_desc = $self->describe_dice(@base_stun_dmg_dice);
	   $base_stun_dmg_dice_desc = $base_stun_dmg_dice_desc && ( $base_stun_dmg_dice_desc ne $base_kill_dmg_dice_desc )
		? " (Stun $base_stun_dmg_dice_desc)" : '';

	my $base_damage_desc = sprintf('Base %s%s %s (+STR[%s] +HL/2[%s])',
			$base_kill_dmg_dice_desc,
			$base_stun_dmg_dice_desc,
			$am_dmg_type,
			$single_str_bonus,
			$half_level_bonus,
	);

	my $unarmed_kill_dmg_dice_desc = $self->describe_dice(@unarmed_kill_dmg_dice);

	my @modes = qw( Normal );

	my @variants;

	my @normal_attack = [ $am_bab, $unarmed_kill_dmg_dice_desc ];
	push @variants, [ 'Normal' => \@normal_attack ];

	my %stats = (
		'name'             => $am_name,
		'notes'            => $self->combat_notes,
		'base_damage_desc' => $base_damage_desc,
		'modes'            => \@modes,
		'variants'         => \@variants,
	);

	return %stats;
}


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



