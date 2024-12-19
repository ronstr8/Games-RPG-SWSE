package Games::RPG::SWSE::Feat::SkillFocus;

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
	   $mods{$skill} = sub { shift->_make_skill_focused(@ARG) };

	return \%mods;
}

sub _make_skill_focused
{
	my($self, $char, $stat, $mod) = @ARG;
	$stat->focused(1);
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

	return sprintf('You have focused extraordinary training on your %s skill.', $sname);
}

## sub _build_description { 'One of your skills is particularly well honed.' }

sub _build_benefit_desc
{
	return <<EOT;

	You gain a +5 competence bonus on skill checks made with one
	trained skill of your choice.

EOT
}

sub _build_normal_desc
{
	return <<EOT;

	This feat may be selected multiple times. Its effects do not stack.
	Each time you take this feat, it applies to a different trained skill.

EOT
}


sub _build_special_desc
{
	return <<EOT;


EOT
}


1;



