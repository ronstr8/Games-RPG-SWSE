package Games::RPG::SWSE::Class::Scoundrel;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Class );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_defense_bonuses                    { +{ 'DefenseFORT' => 0, 'DefenseREF' => 2, 'DefenseWILL' => 1 } }
sub _build_base_attack_bonuses                { +[ 0, qw( 0 1 2 3 3 4 5 6 6 7 8 9 9 10 11 12 12 13 14 15 )] }
sub _build_base_force_points                  { 5   }
sub _build_hit_die                            { 'd6'   }
sub _build_base_trained_skills_at_first_level { 4   }
sub _build_starting_credits_dice              { '3d4x250' }

1;

