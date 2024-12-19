package Games::RPG::SWSE::Skill::KnowledgeLifeSciences;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Skill::Knowledge );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description { q{Biology, botany, genetics, archaeology, xenobiology, medicine, and forensics.} }

1;
