package Games::RPG::SWSE::Feat::VehicularCombat;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_prerequisites { +{ 'SkillPilot' => 5 } }

sub _build_description
{
	return <<EOT;

	You can avoid attacks made against your vehicle.

EOT
}

sub _build_benefit_desc
{
	return <<EOT;

	Once per round (as a reaction), when you are piloting a vehicle
	or starship, you may negate a weapon hit by making a successful
	Pilot check. The DC of the skill check is equal to the result of
	the attack roll you wish to negate.

	In addition, while you are piloting a vehicle, you are considered
	proficient with pilot-operated vehicle weapons. (The vehicle
	descriptions in Chapter 10 indicate which weapons are operated
	by the pilot.)

EOT
}

1;

