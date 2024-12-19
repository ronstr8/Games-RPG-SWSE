package Games::RPG::SWSE::Talent::Bloodthirsty;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name { 'Bloodthirsty!' }
sub _build_tree_id { 'TreePiracy' }

sub _build_description
{
	return <<EOT;

	You can perform a coup de grace as a move action. Whenever you
	successfully perform a coup de grace action and kill the target,
	all allies within your line of sight gain a +2 morale bonus on
	attack rolls for the duration of the encounter.

EOT
}

1;









