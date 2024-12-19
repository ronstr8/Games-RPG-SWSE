package Games::RPG::SWSE::Ability::CHA;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Ability );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name          { 'Charisma'   }
sub _build_display_order { 6            }
sub _build_associated_stats { [qw( SkillDeception SkillGatherInformation SkillPersuasion SkillUseForce )] }

1;
