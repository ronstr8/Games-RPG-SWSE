package Games::RPG::SWSE::Equipment::Unarmed;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::WeaponUnarmed );
no Moose; __PACKAGE__->meta->make_immutable;


1;



