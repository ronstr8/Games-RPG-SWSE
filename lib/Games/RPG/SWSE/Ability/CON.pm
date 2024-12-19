package Games::RPG::SWSE::Ability::CON;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Ability );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name          { 'Constitution' }
sub _build_display_order { 3              }
sub _build_associated_stats { [qw( SkillEndurance DefenseFORT )] }

1;
