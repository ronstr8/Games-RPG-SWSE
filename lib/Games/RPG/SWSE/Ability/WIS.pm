package Games::RPG::SWSE::Ability::WIS;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Ability );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name          { 'Wisdom'       }
sub _build_display_order { 5              }
sub _build_associated_stats { [qw( SkillPerception SkillSurvival SkillTreatInjury DefenseWILL )] }

1;
