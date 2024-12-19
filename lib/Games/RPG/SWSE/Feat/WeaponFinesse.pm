package Games::RPG::SWSE::Feat::WeaponFinesse;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description
{
	return <<EOT;

	You are especially skilled at using weapons such that one can benefit as
	much from Dexterity as from Strength.

EOT
}

sub _build_prerequisites { +{ 'BABBase' => 1 } }

sub _build_benefit_desc
{
	return <<EOT;

	When using a light melee weapon or a lightsaber, you may use your Dexterity
	modifier instead of your Strength modifier on attack rolls.

EOT
}


1;


