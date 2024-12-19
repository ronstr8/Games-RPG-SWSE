package Games::RPG::SWSE::Item::BlasterPistolHeavy;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponRanged );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_weapon_group          { 'Pistol'                  }
sub _build_size                  { 'Medium'                   }
sub _build_cost                  {  750                      }
sub _build_base_kill_damage_dice { '3d8'                     }
sub _build_base_stun_damage_dice { '3d8'                          }
sub _build_fire_rate             { 'Single'                      }
sub _build_weight                {  1.3                      }
sub _build_damage_type           { [qw( Energy )] }
sub _build_availability          { 'Military'                }

1;


