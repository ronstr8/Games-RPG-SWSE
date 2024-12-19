package Games::RPG::SWSE::Talent::VeteranPrivateer;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_tree_id { 'TreeClassPerk' }

sub _build_description
{
	return <<EOT;

	Your experience as a pirate has taught you a variety of tricks to gain
	the upper hand in battle. When you make an attack roll, you can gain
	a +2 competence bonus to that attack roll. You can do this a number of
	times per encounter equal to one-half your class level (rounded down).

EOT
}

1;










