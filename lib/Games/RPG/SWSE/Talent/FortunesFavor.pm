package Games::RPG::SWSE::Talent::FortunesFavor;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name { q{Fortune's Favor} }
sub _build_tree_id { 'TreeFortune' }

sub _build_description
{
	return <<EOT;

	Whenever you score a critical hit with a melee or ranged attack,
	you gain a free standard action.  You must take the extra standard
	action before the end of your turn, or else it is lost.

EOT
}

1;






