package Games::RPG::SWSE::Talent::BlasterAndBladeI;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_tree_id { 'TreePrivateer' }

sub _build_description
{
	return <<EOT;

	A coup d'grace may be attempted as a swift action.  If it succeeds,
	all allies within LOS receive a +2 to attack rolls until the end of
	the encounter.

EOT
}

1;




