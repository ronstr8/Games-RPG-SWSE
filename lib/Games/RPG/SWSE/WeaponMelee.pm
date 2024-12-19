package Games::RPG::SWSE::WeaponMelee;

=head1 NAME

Games::RPG::SWSE::WeaponMelee - An SWSE melee weapon

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;

use Moose;
extends qw( Games::RPG::SWSE::Weapon );

=head1 ATTRIBUTES

Object attributes.

=cut

sub _build_usage_stat_id { 'BABMelee' }
sub _build_damage_bonus_stat_id  { 'AbilitySTR'          }
sub _build_size                  { 'Small'             }
sub _build_cost                  {  100                }
sub _build_weight                {  1                  }
sub _build_availability          { 'Unrestricted'      }
sub _build_weapon_group          { 'Simple'            }
sub _build_damage_type           { [qw( Bludgeoning )] }
sub _build_base_kill_damage_dice { []                  }
sub _build_base_stun_damage_dice { []                  }

override '_build_base_attack_bonus' => sub {
	my $self      = shift;
	my $character = $self->character;
	my $base      = super();

	return $base unless $self->is_light_weapon
		and $character->statistic('FeatWeaponFinesse');

	my $alt = $character->statistic('BABRanged')->modifier;
	return $alt if $alt > $base;
	return $base;
};

no Moose; __PACKAGE__->meta->make_immutable;

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

	my $half_level_bonus  = $self->heroic_level_damage_dice;
	my $single_str_bonus  = $self->single_strength_damage_dice;
	my $double_str_bonus  = $self->double_strength_damage_dice;

	my @base_kill_dmg_dice      = @{ $self->base_kill_damage_dice || [] };
	my @base_stun_dmg_dice      = @{ $self->base_stun_damage_dice || [] };
	my @melee_1H_kill_dmg_dice  = ( @base_kill_dmg_dice, $half_level_bonus, $single_str_bonus );
	my @melee_2H_kill_dmg_dice  = ( @base_kill_dmg_dice, $half_level_bonus, $double_str_bonus );
	
	my $base_kill_dmg_dice_desc = $self->describe_dice(@base_kill_dmg_dice);
	my $base_stun_dmg_dice_desc = $self->describe_dice(@base_stun_dmg_dice);
	   $base_stun_dmg_dice_desc = $base_stun_dmg_dice_desc && ( $base_stun_dmg_dice_desc ne $base_kill_dmg_dice_desc )
		? " (Stun $base_stun_dmg_dice_desc)" : '';

	my $melee_1H_kill_dmg_dice_desc = $self->describe_dice(@melee_1H_kill_dmg_dice);
	my $melee_2H_kill_dmg_dice_desc = $self->describe_dice(@melee_2H_kill_dmg_dice);

	my $base_damage_desc = sprintf('Base %s%s %s (+HL/2[%s])',
			$base_kill_dmg_dice_desc,
			$base_stun_dmg_dice_desc,
			$am_dmg_type,
			$half_level_bonus,
	);

	my @modes = (
		sprintf('1-Handed <code class="writeover">(+STR[%s])</code>',   $single_str_bonus),
		sprintf('2-Handed <code class="writeover">(+STR*2[%s])</code>', $double_str_bonus),
	);

	my @variants;

	my @normal_attack = (
		[ $am_bab, $melee_1H_kill_dmg_dice_desc ],
		[ $am_bab, $melee_2H_kill_dmg_dice_desc ],
	);
	push @variants, [ 'Normal' => \@normal_attack ];

	my $has_rapid_strike = $character->statistic('FeatRapidStrike');
	if ($has_rapid_strike) {
		my @rapid_strike = (
			[ $am_bab-2, $self->describe_dice($melee_1H_kill_dmg_dice_desc, '+1d') ],
			[ $am_bab-2, $self->describe_dice($melee_2H_kill_dmg_dice_desc, '+1d') ],
		);
		push @variants, [ 'Rapid Strike' => \@rapid_strike ];
	}

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



