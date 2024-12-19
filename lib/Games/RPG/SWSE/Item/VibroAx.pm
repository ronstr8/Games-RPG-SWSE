package Games::RPG::SWSE::Item::VibroAx;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponMelee );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_weapon_group          { 'AdvancedMelee'                  }
sub _build_size                  { 'Large'                   }
sub _build_cost                  {  500                      }
sub _build_base_kill_damage_dice { '2d10'                     }
sub _build_base_stun_damage_dice {                           }
sub _build_weight                {  6                      }
sub _build_damage_type           { [qw( Slashing )] }
sub _build_availability          { 'Restricted'                }

1;

