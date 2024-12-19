package Games::RPG::SWSE::Talent::TriggerWork;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_tree_id { 'TreeGunslinger' }

sub _build_description
{
	return <<EOT;

	You take no penalty on your attack roll when using the Rapid Shot feat.

EOT
}

1;



