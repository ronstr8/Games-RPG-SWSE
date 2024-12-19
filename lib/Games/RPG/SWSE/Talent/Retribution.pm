package Games::RPG::SWSE::Talent::Retribution;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_tree_id { 'TreeOpportunist' }

sub _build_description
{
	return <<EOT;

	When a target moves one of your allies in your line of sight down the
	condition track by any means, you gain a +2 insight bonus to your
	attack rolls against that target until the end of your next turn.

EOT
}

1;




