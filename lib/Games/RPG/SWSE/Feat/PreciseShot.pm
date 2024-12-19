package Games::RPG::SWSE::Feat::PreciseShot;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description
{
	return <<EOT;

	You are skilled at timing your ranged attacks so that you don't hit your
	allies by mistake.

EOT
}

sub _build_prerequisites { +{ 'SkillPointBlankShot' => 1 } }

sub _build_benefit_desc
{
	return <<EOT;

	You can shoot or throw a ranged weapon at an opponent engaged in melee
	combat with one or more of your allies without taking the standard -5
	penalty (see Shooting or Throwing into a Melee, CORE161).

EOT
}

1;


