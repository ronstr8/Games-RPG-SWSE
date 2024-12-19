package Games::RPG::SWSE::Skill::Perception;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Skill );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_can_use_untrained       { 1            }
sub _build_has_armor_check_penalty { 0            }

1;
