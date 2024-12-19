package Games::RPG::SWSE::Feat::MartialArtsII;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );

no Moose; __PACKAGE__->meta->make_immutable;

## TODO :: Modify base unarmed die damage...

sub _build_prequisites { +{ 'FeatMartialArtsI' => 1, 'BABBase' => 3 } }
sub _build_modifier_of { +{ 'DefenseREF' => 1 } }

sub _build_description
{
	return <<EOT;

	You are a master at fighting unarmed.

EOT
}

sub _build_benefit_desc
{
	return <<EOT;

	Damage dealt by your unarmed attacks increases by one die step:
	1d4 becomes 1d6, 1d6 becomes 1d8, and 1d8 becomes 1d10. In addition, you
	gain a +1 dodge bonus to your Reflex Defense (which stacks with the dodge
	bonus granted by the Martial Arts I feat).

EOT
}

sub _build_normal_desc
{
	return <<EOT;

	The amount of damage you deal with a successful unarmed
	attack is based on your size: Small, 1d3; Medium, 1d4; Large, 1d6.

EOT
}

sub _build_special_desc
{
	return <<EOT;

	A situation that makes you lose your Dexterity bonus to Reflex
	Defense (if any) also makes you lose dodge bonuses. Also, dodge bonuses
	stack with each other, unlike most other types of bonuses.

EOT
}

1;


