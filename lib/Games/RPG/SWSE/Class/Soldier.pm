package Games::RPG::SWSE::Class::Soldier;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Class );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_defense_bonuses                    { +{ 'DefenseFORT' => 2, 'DefenseREF' => 1, 'DefenseWILL' => 0 } }
sub _build_base_attack_bonuses                { +[ 0, qw( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 )] }
sub _build_base_force_points                  { 5   }
sub _build_hit_die                            { 'd10'  }
sub _build_base_trained_skills_at_first_level { 3   }
sub _build_starting_credits_dice              { '3d4x250' }

1;


