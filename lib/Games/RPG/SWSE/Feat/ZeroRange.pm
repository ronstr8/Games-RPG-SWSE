package Games::RPG::SWSE::Feat::ZeroRange;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description
{
	return <<EOT;

	You are lethal when using ranged weapons against adjacent targets.

EOT
}

sub _build_prerequisites { +{ 'FeatPointBlankShot' => 1 } }

sub _build_benefit_desc
{
	return <<EOT;

	When firing a ranged weapon at a target within or adjacent to your
	fighting space, you gain a +1 bonus on the attack roll and deal a
	+1 die of damage on a hit.

	The effects of this feat do not stack with the extra damage provided
	by the Burst Fire or Rapid Shot feats.  This feat does not apply to
	heavy weapons or vehicle weapons, or in starship combat.

EOT
}

1;


