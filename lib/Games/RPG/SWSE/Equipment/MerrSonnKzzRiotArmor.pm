package Games::RPG::SWSE::Equipment::MerrSonnKzzRiotArmor;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Armor );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name                     { 'Merr-Sonn KZZ Riot Armor' };
sub _build_cost                     { 2500 }
sub _build_armor_group              { 'Light' }
sub _build_ref_defense_bonus        { 2 }
sub _build_fort_defense_bonus       { 2 }
sub _build_maximum_dex_reflex_bonus { 5 }

1;

