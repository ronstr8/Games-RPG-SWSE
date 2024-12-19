package Games::RPG::SWSE::Talent::ImprovedArmoredDefense;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_prerequisites { +{ 'TalentArmoredDefense' => 1 } }
sub _build_tree_id { 'TreeArmorSpecialist' }

sub _build_description
{
	return <<EOT;

	When calculating your Reflex Defense, you may add your heroic level
	plus one-half your armor bonus (rounded down) or your armor bonus,
	whichever is higher. You must be proficient with the armor you are
	wearing to gain this benefit.

EOT
}


1;

