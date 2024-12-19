package Games::RPG::SWSE::Defense::WILL;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Defense );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name                    { 'Willpower'   }
sub _build_display_order           { 3             }

1;
