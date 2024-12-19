package Games::RPG::SWSE::Defense::FORT;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Defense );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name                    { 'Fortitude'  }
sub _build_display_order           { 1            }

1;
