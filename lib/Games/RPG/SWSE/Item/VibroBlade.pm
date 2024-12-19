package Games::RPG::SWSE::Item::VibroBlade;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponMelee );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_weapon_group          { 'AdvancedMelee'                  }
sub _build_size                  { 'Small'                   }
sub _build_cost                  {  250                      }
sub _build_base_kill_damage_dice { '2d6'                     }
sub _build_base_stun_damage_dice {                           }
sub _build_weight                {  1.8                      }
sub _build_damage_type           { [qw( Slashing Piercing )] }
sub _build_availability          { 'Licensed'                }

1;
