package Games::RPG::SWSE::Feat::SkillTraining;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_modifier_of
{
	my $self  = shift;
	my $skill = $self->get_scarg('skill');

	my %mods;
	   $mods{$skill} = sub { shift->_make_skill_trained(@ARG) };

	return \%mods;
}

sub _make_skill_trained
{
	my($self, $char, $stat, $mod) = @ARG;
	$stat->trained(1);
	return;
}

sub describe_modifiers
{
	my($self, $char, $stat, $current_mod) = @ARG;
	return unless $self->is_modifier_of($stat->id);
	return $self->nick . '/+5';
}

sub _build_blurb_desc { shift->description }

sub _build_description
{
	my $self  = shift;
	my $scarg = $self->get_scarg('skill');
	my $scobj = $self->character->statistic($scarg);
	my $sname = $scobj->name;

	return sprintf('You have basic professional training in the %s skill.', $sname);
}


## sub _build_description { 'You are considered trained in a new skill.' }

sub _build_benefit_desc
{
	return <<EOT;

	Choose one untrained skill from your list of class skills. You
	become trained in that skill.

EOT
}

sub _build_normal_desc
{
	return <<EOT;


EOT
}


sub _build_special_desc
{
	return <<EOT;

	This feat may be selected multiple times. Each time you take
	this feat, it applies to a different class skill.

EOT
}


1;


