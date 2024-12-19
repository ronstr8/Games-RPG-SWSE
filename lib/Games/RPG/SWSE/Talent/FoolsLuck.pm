package Games::RPG::SWSE::Talent::FoolsLuck;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name { q{Fool's Luck} }
sub _build_tree_id { 'TreeFortune' }

sub _build_description
{
	return <<EOT;

	As a standard action, you can spend a Force Point to gain one of
	the following benefit for the rest of the encounter: a +1 competence
	bonus on attack rolls, a +5 competence bonus on skill checks, or a
	+1 competence bonus to all your defenses.

EOT
}

1;







