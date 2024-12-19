package Games::RPG::SWSE::Feat::ArmorProficiencyLight;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name { 'Armor Proficiency (Light)' }

sub _build_description
{
	return <<EOT;

	You are proficient with light armor (see Table 8-7: Armor) and can wear it
	without impediment.

EOT
}

sub _build_benefit_desc
{
	return <<EOT;

	When you wear light armor, you take no armor check penalty on attack
	rolls or skill checks. Additionally, you benefit from all of the armor's
	special equipment bonuses (if any).

EOT
}

sub _build_normal_desc
{
	return <<EOT;

	A character who wears heavy armor with which she is not proficient
	takes a -2 armor check penalty on attack rolls as well as skill checks
	made using the following skills: Acrobatics, Climb, Endurance,
	Initiative, Jump, Stealth, and Swim. Additionally, the character
	gains none of the armor's special equipment bonuses.

EOT
}

1;

