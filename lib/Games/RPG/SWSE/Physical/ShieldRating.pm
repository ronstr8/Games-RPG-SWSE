package Games::RPG::SWSE::Physical::ShieldRating;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Physical );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_display_order { 0 }  ## TBI
sub _build_score         { 0 }

1;


