package Games::RPG::SWSE::Skill::KnowledgeSocialSciences;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Skill::Knowledge );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description { q{Sociology, psychology, philosophy, theology, and criminology.} }

1;
