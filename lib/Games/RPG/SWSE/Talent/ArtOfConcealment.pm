package Games::RPG::SWSE::Talent::ArtOfConcealment;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_tree_id { 'TreeSmuggling' }

sub _build_description
{
	return <<EOT;

	Some smugglers are adept at hiding contraband and weapons, even
	on their person.  When making a Stealth check to conceal an item,
	you can take 10 even under pressure.  Additionally, you can
	conceal an item as a swift action.

EOT
}

1;








