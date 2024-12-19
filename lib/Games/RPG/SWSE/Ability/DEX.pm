package Games::RPG::SWSE::Ability::DEX;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Ability );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name          { 'Dexterity'    }
sub _build_display_order { 2              }
sub _build_associated_stats { [qw( SkillAcrobatics SkillInitiative SkillPilot SkillRide SkillStealth DefenseREF BABRanged )] }

1;
