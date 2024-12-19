package Games::RPG::SWSE::Equipment::BootSpike;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponUnarmed );
override '_build_base_any_damage_dice' => sub { [ (@{ super() }), qw( d++ ) ] };
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_weapon_group          { 'Simple'            }
sub _build_size                  { 'Fine'              }
sub _build_cost                  {  250                }
sub _build_weight                {  0.5                }
sub _build_damage_type           { [qw( Piercing )]    }
sub _build_availability          { 'Unrestricted'      }

1;




