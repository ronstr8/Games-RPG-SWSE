package Games::RPG::SWSE::Feat::DualWeaponMasteryIII;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name { 'Dual Weapon Mastery III' }

sub _build_description
{
	return <<EOT;

	You are a master at fighting with two weapons and double weapons.

EOT
}

sub _build_prerequisites { +{ 'BABBase' => 6, 'AbilityDEX' => 15, 'FeatDualWeaponMasteryII' => 1 } }

sub _build_benefit_desc
{
	return <<EOT;

	When you attack with two weapons or both ends of a double weapon as part of
	a full attack action, you take no penalty (instead of a -10 penalty) on
	all attack rolls until the start of your next turn.  You only gain this
	reduced penalty if you are wielding a weapon with which you are proficient.

EOT
}

sub _build_normal_desc
{
	return <<EOT;

	If you use a full attack action to make more than one attack on your turn
	(see Full Attack, CORE154), you take a -10 penalty on all attack rolls for
	the round.

EOT
}


1;


