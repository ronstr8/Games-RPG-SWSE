package Games::RPG::SWSE::Equipment::BlasterPistolHoldOut;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponRanged );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name                  { 'Holdout Blaster Pistol'  }
sub _build_weapon_group          { 'Pistol'                  }
sub _build_size                  { 'Tiny'                    }
sub _build_cost                  {  300                      }
sub _build_base_kill_damage_dice { [qw( 3d4 )]               }
sub _build_base_stun_damage_dice {                           }
sub _build_fire_rate             { 'Single'                  }
sub _build_weight                {  0.5                      }
sub _build_damage_type           { [qw( Energy )]            }
sub _build_availability          { 'Illegal'                 }

1;


