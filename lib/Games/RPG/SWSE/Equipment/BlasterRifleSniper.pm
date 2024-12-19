package Games::RPG::SWSE::Equipment::BlasterRifleSniper;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponRanged );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name                  { 'Sniper Blaster'   }
sub _build_weapon_group          { 'Rifle'            }
sub _build_size                  { 'Small'            }
sub _build_cost                  {  2000              }
sub _build_base_kill_damage_dice { [qw( 3d10 )]       }
sub _build_base_stun_damage_dice {                    }
sub _build_fire_rate             { 'Single'           }
sub _build_weight                {  8                 }
sub _build_damage_type           { [qw( Energy )]     }
sub _build_availability          { 'Military'         }

1;



