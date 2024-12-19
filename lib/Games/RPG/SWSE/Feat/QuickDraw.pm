package Games::RPG::SWSE::Feat::QuickDraw;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description
{
	return <<EOT;

	You can draw and holster weapons with startling quickness.

EOT
}

sub _build_prerequisites { +{ 'BABBase' => 1 } }

sub _build_benefit_desc
{
	return <<EOT;

	You can draw or holster a weapon as a swift action instead of a move action.

EOT
}

1;
