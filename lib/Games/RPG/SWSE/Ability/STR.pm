package Games::RPG::SWSE::Ability::STR;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Ability );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name          { 'Strength'     }
sub _build_display_order { 1              }
sub _build_associated_stats { [qw( SkillClimb SkillJump SkillSwim BABMelee )] }

1;
