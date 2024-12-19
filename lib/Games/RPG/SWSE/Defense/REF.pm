package Games::RPG::SWSE::Defense::REF;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Defense );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name                    { 'Reflex'      }
sub _build_display_order           { 2             }

1;
