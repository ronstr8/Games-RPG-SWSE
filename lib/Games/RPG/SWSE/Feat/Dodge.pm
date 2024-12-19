package Games::RPG::SWSE::Feat::Dodge;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_prerequisites { +{ 'AbilityDEX' => 13 } }

sub _build_description
{
	return <<EOT;

	You are adept at dodging blows.

EOT
}

sub _build_benefit_desc
{
	return <<EOT;

	During your turn, you designate an opponent and receive a +1 dodge
	bonus to your Reflex Defense against attacks from that opponent.  You
	can select a new opponent on any action.

	A situation that makes you lose your Dexterity bonus to Reflex Defense
	(if any) also makes you lose dodge bonuses. Also, dodge bonuses stack with
	each other, unlike most other types of bonuses.

EOT
}

1;

