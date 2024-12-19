package Games::RPG::SWSE::Talent::UncannyLuck;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;


sub _build_prerequisites { +{ 'TalentKnack' => 1, 'TalentLuckyShot' => 1 } }
sub _build_tree_id { 'TreeFortune' }

sub _build_description
{
	return <<EOT;

	Once per encounter, you can consider any single d20 roll
	of 16 or higher to be a natural 20.

EOT
}

1;








