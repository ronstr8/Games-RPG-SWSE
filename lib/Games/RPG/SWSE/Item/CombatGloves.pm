package Games::RPG::SWSE::Item::CombatGloves;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponMelee );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_weapon_group          { 'Simple'                  }
sub _build_size                  { 'Fine'                   }
sub _build_cost                  {  250                      }
sub _build_base_kill_damage_dice { '+1'                     }
sub _build_base_stun_damage_dice {                           }
sub _build_weight                {  0.5                      }
sub _build_damage_type           { [qw( Bludgeoning )] }
sub _build_availability          { 'Unestricted'                }

1;



