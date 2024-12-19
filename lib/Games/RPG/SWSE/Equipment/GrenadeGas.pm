package Games::RPG::SWSE::Equipment::GrenadeGas;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponThrown );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name                  { 'Gas Grenade'   }
sub _build_size                  { 'Tiny'          }
sub _build_cost                  {  250            }
sub _build_base_kill_damage_dice { [qw(     )]     }
sub _build_base_stun_damage_dice { [qw( 4d6 )]     }
sub _build_fire_rate             { 'Single'        }
sub _build_weight                {  0.5            }
sub _build_damage_type           { [qw( Energy )]  }
sub _build_availability          { 'Military'      }
sub _build_combat_notes          { q{ 4sq Burst; Attack v.FORT=COND-2; Targets concealed } }

1;



