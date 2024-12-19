package Games::RPG::SWSE::Talent::Spacehound;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_tree_id { 'TreeSpacer' }

sub _build_description
{
	return <<EOT;

	You take no penalty on attack rolls in low-gravity or zero-gravity
	environments, and you ignore the debilitating effects of space
	sickness (see Zero-Gravity Environments, CORE257). In addition, you
	are considered proficient with any starship weapon.

EOT
}

1;





