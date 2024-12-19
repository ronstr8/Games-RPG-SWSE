package Games::RPG::SWSE::Feat::PointBlankShot;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description
{
	return <<EOT;

	You are skilled at making well-placed shots with ranged weapons at point
	blank range.

EOT
}

sub _build_prerequisites { +{} }

sub _build_benefit_desc
{
	return <<EOT;

	You get a +1 bonus on attack and damage rolls with ranged weapons against
	opponents within point blank range (See Table 8-5: Weapon Ranges, CORE129).

EOT
}

1;

