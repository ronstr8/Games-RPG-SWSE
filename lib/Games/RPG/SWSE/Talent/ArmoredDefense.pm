package Games::RPG::SWSE::Talent::ArmoredDefense;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Talent );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_tree_id { 'TreeArmorSpecialist' }

sub _build_description
{
	return <<EOT;

	When calculating your Reflex Defense, you may add either your
	heroic level or your armor bonus, whichever is higher. You must
	be proficient with the armor you are wearing to gain this benefit.

EOT
}

1;


