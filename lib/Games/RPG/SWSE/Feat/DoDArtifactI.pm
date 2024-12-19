package Games::RPG::SWSE::Feat::DoDArtifactI;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_name { 'DoD Artifact I' };

sub _build_modifier_of
{
	my $self      = shift;
	my @abilities = qw( AbilityDEX );

	my %mods;

	foreach my $stat_id (@abilities) {
	   $mods{$stat_id} = sub { shift->_increase_ability(@ARG) };
	}

	return \%mods;
}

sub _increase_ability
{
	my($self, $char, $stat, $mod) = @ARG;
	$stat->inc_score; ## $stat->score( $stat->score + 1 );
	$stat->clear_modifier;
	return;
}

sub _build_description
{
	return <<EOT;

	Campaign-specific GM feat for crafting an item belonging to
	or reminiscent of your character.  (Leather Ryll kit with
	a kinda absinthe bottle/spoon and drink.)

EOT
}

sub _build_special_desc
{
	return <<EOT;

	Add 1 to any attribute.

EOT
}

sub describe_modifiers
{
	my($self, $char, $stat, $current_mod) = @ARG;

	return unless $self->is_modifier_of($stat->id);
	return "RyllKit/+1";
}

1;


