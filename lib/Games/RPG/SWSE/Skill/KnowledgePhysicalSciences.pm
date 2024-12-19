package Games::RPG::SWSE::Skill::KnowledgePhysicalSciences;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Skill::Knowledge );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description { q{Astronomy, astrogation, chemistry, mathematics, physics, and engineering.} }

1;
