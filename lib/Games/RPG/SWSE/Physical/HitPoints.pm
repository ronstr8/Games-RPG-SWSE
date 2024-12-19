package Games::RPG::SWSE::Physical::HitPoints;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Physical );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_display_order { 10 }
sub _build_score         {  shift->character->hit_points }

1;


