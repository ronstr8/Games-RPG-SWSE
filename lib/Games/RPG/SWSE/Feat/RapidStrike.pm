package Games::RPG::SWSE::Feat::RapidStrike;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description
{
	return <<EOT;

	You can make two quick strikes with a melee weapon as a single attack.

EOT
}

sub _build_prerequisites { +{ 'BABBase' => 1 } }

sub _build_benefit_desc
{
	return <<EOT;

	When using a melee weapon, you may make two strikes as a single attack
	against a single target.  You take a -2 penalty on your attack roll,
	but you deal +1 die of damage with a successful attack.  If you do not
	have a Dexterity of 13 or higher, increase the penalty to -5 when using
	this feat with a non-light weapon.

	The effects of this feat do not stack with the extra damage provided by
	the Mighty Swing feat.

EOT
}

1;



