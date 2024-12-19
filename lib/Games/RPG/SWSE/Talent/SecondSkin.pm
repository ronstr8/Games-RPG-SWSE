package Games::RPG::SWSE::Talent::SecondSkin;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_modifier_of { +{ 'DefenseREF' => 1, 'DefenseFORT' => 1 } }
sub _build_prerequisites { +{ 'TalentArmoredDefense' => 1 } }
sub _build_tree_id { 'TreeArmorSpecialist' }

sub _build_description
{
	return <<EOT;

	When wearing armor with which you are proficient, your
	armor bonus to your Reflex Defense and equipment bonus
	to your Fortitude Defense increase by +1.
EOT
}


1;


