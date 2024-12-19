package Games::RPG::SWSE::Equipment::Knife;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponMelee );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_weapon_group          { 'Simple'                  }
sub _build_size                  { 'Tiny'                   }
sub _build_cost                  {  25                      }
sub _build_base_kill_damage_dice { [qw( 1d4  )]                   }
sub _build_base_stun_damage_dice {                           }
sub _build_weight                {  1                      }
sub _build_damage_type           { [qw( Slashing Piercing )] }
sub _build_availability          { 'Unestricted'                }

1;


