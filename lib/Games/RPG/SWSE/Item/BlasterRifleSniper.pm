package Games::RPG::SWSE::Item::BlasterRifleSniper;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponRanged );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_weapon_group          { 'Rifle'                  }
sub _build_size                  { 'Large'                   }
sub _build_cost                  {  2000                      }
sub _build_base_kill_damage_dice { '3d10'                     }
sub _build_base_stun_damage_dice {                          }
sub _build_fire_rate             { 'Single'                      }
sub _build_weight                {  8                      }
sub _build_damage_type           { [qw( Energy )] }
sub _build_availability          { 'Military'                }

1;



