package Games::RPG::SWSE::Weapon;

=head1 NAME

Games::RPG::SWSE::Weapon - An SWSE weapon

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
## enum 'SwseWeaponGroup'       => qw( AdvancedMelee Exotic Lightsaber Simple Unarmed Heavy Pistol Rifle );
## enum 'SwseWeaponDamageType'  => qw( Slashing Piercing Bludgeoning Energy Ion Fire  );
## enum 'SwseWeaponFireRate'    => qw( Single Auto );

use Moose;
extends qw( Games::RPG::SWSE::Equipment );

=head1 ATTRIBUTES

Object attributes.

=cut

has 'combat_notes' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_combat_notes { '' }

has 'usage_stat_id' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_usage_stat_id { 'BABMelee' }


has 'weapon_group' => (
	'is'         => 'rw',
	'isa'        => 'SwseWeaponGroup',
	'lazy_build' => 1,
);
sub _build_weapon_group { 'Simple' }

has 'damage_type' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[SwseWeaponDamageType]',
	'lazy_build' => 1,
);
sub _build_damage_type { [qw( Bludgeoning )] }

has 'base_kill_damage_dice' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[Str]',
	'lazy_build' => 1,
);
sub _build_base_kill_damage_dice { '1d6' }

has 'base_stun_damage_dice' => (
	'is'         => 'rw',
	'isa'        => 'Maybe[ArrayRef[Str]]',
	'lazy_build' => 1,
);
sub _build_base_stun_damage_dice { }

has 'is_light_weapon' => (
	'is'         => 'rw',
	'isa'        => 'Int',
	'lazy_build' => 1,
);
sub _build_is_light_weapon
{
	my $self      = shift;
	my $character = $self->character;

	my $character_size_class = $self->character->size_class;
	my $size_class           = $self->size_class;
	return $size_class < $character_size_class ? 1 : 0;
}

has 'base_attack_bonus' => (
	'is'         => 'rw',
	'isa'        => 'Int',
	'lazy_build' => 1,
);
sub _build_base_attack_bonus
{
	my $self = shift;
	$self->character->statistic($self->usage_stat_id)->modifier;
}

no Moose; __PACKAGE__->meta->make_immutable;

=head1 METHODS

Methods called on an instantiated object.

=cut

sub kill_damage_dice
{
	my $self = shift;
	return $self->base_kill_damage_dice;
}

sub stun_damage_dice
{
	my $self = shift;
	return $self->base_stun_damage_dice;
}

sub heroic_level_damage_dice
{
	my $self      = shift;
	my $character = $self->character;

	my $half_level_bonus  = int($character->heroic_level / 2);
	   $half_level_bonus  = "+$half_level_bonus";

	return $half_level_bonus;
}

sub single_strength_damage_dice
{
	my $self      = shift;
	my $character = $self->character;

	my $single_str_bonus  = int($character->statistic('AbilitySTR')->modifier);
	   $single_str_bonus  = ( $single_str_bonus < 1 ) ? "-$single_str_bonus" : "+$single_str_bonus";

	return $single_str_bonus;
}

sub double_strength_damage_dice
{
	my $self      = shift;
	my $character = $self->character;

	my $single_str_bonus = $self->single_strength_damage_dice;
	return $single_str_bonus < 1 ? $single_str_bonus : ('+' . $single_str_bonus * 2);
}

sub combat_stats
{
	my $self      = shift;

	my %stats = (
		'name'             => $self->name,
		'notes'            => $self->combat_notes,
		'base_damage_desc' => 'N/A',
		'variants'         => [ [ 'Normal' => [ '', '' ] ] ],
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



