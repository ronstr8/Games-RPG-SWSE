package Games::RPG::SWSE::Physical::Speed;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Physical );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_display_order { 30 }
sub _build_score         {  6 }

1;

