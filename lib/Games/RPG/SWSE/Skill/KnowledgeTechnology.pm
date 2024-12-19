package Games::RPG::SWSE::Skill::KnowledgeTechnology;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Skill::Knowledge );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description { q{Function and principle of technological devices, as well as knowledge of cutting edge theories and advancements.} }

1;

