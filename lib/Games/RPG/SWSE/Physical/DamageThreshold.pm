package Games::RPG::SWSE::Physical::DamageThreshold;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Physical );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_display_order { 20 }
sub _build_score { my $self = shift; $self->character->defense('FORT')->modifier };

1;



