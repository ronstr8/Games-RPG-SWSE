package Games::RPG::SWSE::Class::Gunslinger;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Class );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_defense_bonuses                    { +{ 'DefenseFORT' => 0, 'DefenseREF' => 4, 'DefenseWILL' => 0 } }
sub _build_base_attack_bonuses                { +[ 0, qw( 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 )] }
sub _build_base_force_points                  {  6   }
sub _build_hit_die                            { 'd8'   }

1;



