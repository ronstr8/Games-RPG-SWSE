package Games::RPG::SWSE::Armor;

=head1 NAME

Games::RPG::SWSE::Armor - An SWSE armor

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;

use Games::RPG::SWSE::Skill;
use Games::RPG::SWSE::TypeConstraints;

## use Moose::Util::TypeConstraints;
## enum 'SwseArmorGroup' => qw( Light Medium Heavy );

use Moose;
extends qw( Games::RPG::SWSE::Equipment );

=head1 ATTRIBUTES

Object attributes.

=cut

has 'armor_check_penalty' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_armor_check_penalty {
	my $self = shift;

	my %mods = (
		'Light'  =>  -2,
		'Medium' =>  -5,
		'Heavy'  => -10,
	);
	return $mods{$self->armor_group};
}

sub _build_cost { 0 }

has 'maximum_dex_reflex_bonus' => (
	'is'         => 'rw',
	'isa'        => 'Int',
	'lazy_build' => 1,
);
sub _build_maximum_dex_reflex_bonus { }

has 'speed_modifier' => (
	'is'         => 'rw',
	'isa'        => 'Num',
	'lazy_build' => 1,
);
sub _build_speed_modifier { my $self = shift; $self->armor_group eq 'Light' ? 1 : 0.75 }

has 'armor_group' => (
	'is'         => 'rw',
	'isa'        => 'SwseArmorGroup',
	'lazy_build' => 1,
);
sub _build_armor_group { 'Light' }

has 'fort_defense_bonus' => (
	'is'         => 'rw',
	'isa'        => 'Int',
	'lazy_build' => 1,
);
sub _build_fort_defense_bonus {}

has 'ref_defense_bonus' => (
	'is'         => 'rw',
	'isa'        => 'Int',
	'lazy_build' => 1,
);
sub _build_ref_defense_bonus {}

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_modifier_of
{
	my $self  = shift;

	my %mods;

	$mods{'DefenseFORT'}   = sub { shift->apply_armor_fort_defense_mod(@ARG) };
	$mods{'DefenseREF'}    = sub { shift->apply_armor_reflex_defense_mod(@ARG) };
	$mods{'PhysicalSpeed'} = sub { shift->apply_armor_speed_mod(@ARG) };
	$mods{'PhysicalDamageThreshold'} = sub { shift->apply_armor_fort_defense_mod(@ARG) };

	## BUG :: Inefficient way to get skills that need an armor check penalty.

	my @all_skills  = @{ Games::RPG::SWSE::Skill->new->all_subclass_kids };
	my $acp_applier = sub { shift->apply_armor_check_penalty(@ARG) };
	my @acp_stats   = ( qw( BABRanged BABMelee ), ( map { $ARG->id }
		grep { $ARG->has_armor_check_penalty } @all_skills ) );

	$mods{$ARG} = $acp_applier for @acp_stats;

	return \%mods;
}

sub char_is_proficient
{
	my($self, $char) = @ARG;

	my $group = $self->armor_group;

	foreach my $feat (( @{ $char->feats } )) {
		next unless my $nick =  $feat->nick;
		next unless    $nick =~ m{ArmorProficiency(?<group>\w+)};
		return 1 if $+{'group'} eq $group;
	}

	return 0;
}

sub apply_armor_check_penalty
{
	my($self, $char, $stat, $mod) = @ARG;
	return 0 if $self->char_is_proficient($char);
	return $self->armor_check_penalty;
}

sub apply_armor_reflex_defense_mod
{
	my($self, $char, $stat, $current_mod) = @ARG;

	my $mod = 0;
	return $mod unless $self->char_is_proficient($char);

	my $dex_reflex_bonus     = $char->ability('DEX')->modifier;
	my $max_dex_reflex_bonus = $self->maximum_dex_reflex_bonus;

	if ($dex_reflex_bonus > $max_dex_reflex_bonus) {
		$mod += $max_dex_reflex_bonus - $dex_reflex_bonus;
	}

	my $armor_reflex_bonus = $self->ref_defense_bonus;
	my $heroic_level       = $char->heroic_level;
	my $armored_defense    = $char->talent('ArmoredDefense');
	   $armored_defense    = $armored_defense && $armored_defense->rank;

	if (not $armored_defense) {
		return $mod + ( $armor_reflex_bonus - $heroic_level );
	}

	my $improved_armored_defense = $char->talent('ImprovedArmoredDefense');
	   $improved_armored_defense = $improved_armored_defense && $improved_armored_defense->rank;

	if ($improved_armored_defense) {
		## Improved armored defense allows one to add half the reflex bonus.
		my $half_bonus = int($armor_reflex_bonus / 2);
		my $hl_plus_half_bonus = $heroic_level + $half_bonus;

		## Or just the reflex bonus, if it's higher.
		if ($hl_plus_half_bonus > $armor_reflex_bonus) {
			$mod += $half_bonus;
		}
		else {
			$mod += $armor_reflex_bonus;
		}
	}
	elsif ($heroic_level > $armor_reflex_bonus) {
		## Let it be as per default.
	}
	else {
		## Remove the heroic level bonus and add our bonus.
		$mod += ( $armor_reflex_bonus - $heroic_level );
	}

	return $mod;
}


sub apply_armor_fort_defense_mod
{
	my($self, $char, $stat, $mod) = @ARG;

	return $self->fort_defense_bonus if $self->char_is_proficient($char);
	return 0;
}

sub apply_armor_speed_mod
{
	my($self, $char, $stat, $mod) = @ARG;

	my $speed_modifier = $self->speed_modifier;
	my $current_score = $stat->score;
	$stat->score(int($current_score * $speed_modifier));
}

=head2 describe_modifiers ( Games::RPG::SWSE::Character, Games::RPG::SWSE::Base, $current_mod )

Return a description of the modifier explained above.

=cut

sub describe_modifiers
{
	my $self = shift;
	my($char, $stat, $current_mod) = @ARG;

	my $stat_id = $stat->id;
	return unless $self->is_modifier_of($stat_id);

	my $mod;
	my $nick = $self->nick;

	if ($stat_id =~ /DefenseFORT/) {
		$mod = $self->apply_armor_fort_defense_mod(@ARG);
	}
	elsif ($stat_id =~ /DefenseREF/) {
		$mod = $self->apply_armor_reflex_defense_mod(@ARG);
	}
	elsif ($stat_id =~ /Speed/) {
		my $speed_mod = $self->speed_modifier;
		if (( $speed_mod || 0) != 1) {
			$mod = $self->apply_armor_speed_mod(@ARG);
		}
	}
	elsif ($stat_id =~ /Skill|BAB/) {
		$mod = $self->apply_armor_check_penalty(@ARG);
	}
	else {
		$self->_debug("No relevant modifier for stat-id $stat_id and armor $nick!");
		return;
	}

	return unless $mod;
	return $self->nick . '/' . ( ( $mod < 0 ) ? '-' : '+' ) . abs($mod);
}


=head1 METHODS

Methods called on an instantiated object.

=cut


1;

__END__

=head1 SEE ALSO

=over

=item * L<Something> - Does something

=back

=head1 AUTHOR

Ron "Quinn" Straight E<lt>quinnfazigu@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Public domain.  Free to use and distribute, attribution appreciated.

=cut



