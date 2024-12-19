package Games::RPG::SWSE::Equipment::SithAlchemyBlade;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponMelee );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_weapon_group          { 'AdvancedMelee'           }
sub _build_size                  { 'Small'                  }
sub _build_cost                  {  500                      }
sub _build_base_kill_damage_dice { [qw( 3d8 )]               }
sub _build_base_stun_damage_dice {                           }
sub _build_weight                {  1.5                      }
sub _build_damage_type           { [qw( Energy )]            }
sub _build_availability          { 'Rare'                    }
sub _build_combat_notes          { q{Crit adds +1d10 damage ... and one dark side point.} }

1;

