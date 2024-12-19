package Games::RPG::SWSE::Ability::INT;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Ability );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name          { 'Intelligence' }
sub _build_display_order { 4              }

sub _build_associated_stats
{
	my $self = shift;

	my @all_stat_ids     = $self->character->statistic_ids;
	my @knowledge_skills = grep { /Knowledge/ } @all_stat_ids;

	my @stat_id = ( qw( SkillMechanics SkillUseComputer ), @knowledge_skills );

	return \@stat_id;
}

1;
