package Games::RPG::SWSE::Skill::KnowledgeGalacticLore;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Skill::Knowledge );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description { q{Planets, homeworlds, sectors of space, galactic history, and the Force.} }

1;
