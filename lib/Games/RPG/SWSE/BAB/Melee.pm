package Games::RPG::SWSE::BAB::Melee;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::BAB );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name                    { 'BAB - Melee' }
sub _build_display_order           { 1             }

1;
