package Games::RPG::SWSE::Skill::KnowledgeTactics;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Skill::Knowledge );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description { q{Techniques and strategies for disposing and maneuvering forces in combat.} }

1;
