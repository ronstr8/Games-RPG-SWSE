package Games::RPG::SWSE::BAB::Ranged;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::BAB );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name                    { 'BAB - Ranged' }
sub _build_display_order           { 2             }

1;

