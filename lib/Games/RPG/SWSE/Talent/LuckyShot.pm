package Games::RPG::SWSE::Talent::LuckyShot;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_prerequisites { +{ 'TalentKnack' => 1 } }
sub _build_tree_id { 'TreeFortune' }

sub _build_description
{
	return <<EOT;

	Once per day, you can reroll an attack roll and take the better
	result.

	You can select this talent multiple times; each time you select
	this talent, you can use it one additional time per day.

EOT
}

1;









