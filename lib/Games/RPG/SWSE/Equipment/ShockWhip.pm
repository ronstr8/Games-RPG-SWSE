package Games::RPG::SWSE::Equipment::ShockWhip;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponMelee );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_weapon_group          { 'AdvancedMelee'           }
sub _build_size                  { 'Small'                   }
sub _build_cost                  {  1200                     }
sub _build_base_kill_damage_dice { [qw( 1d6 )]               }
sub _build_base_stun_damage_dice {                           }
sub _build_weight                {  2.3                      }
sub _build_damage_type           { [qw( Bludgeoning )]       }
sub _build_availability          { 'Restricted'              }
sub _build_combat_notes          { q{ 2sq Reach; Free Atk=Grab, Swift/Turn +2d6dmg } }

1;


