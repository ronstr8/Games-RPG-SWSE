package Games::RPG::SWSE::Ability;

=head1 NAME

Games::RPG::SWSE::Ability - An SWSE ability

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;

use Moose;
extends qw( Games::RPG::SWSE::Base );

=head1 ATTRIBUTES

Object attributes.

=cut

has '+character' => (
	'required' => 1,
);

has '+score' => (
	'trigger'    => sub { my $self = shift; $self->_add_as_modifying_stat; },
);

has 'associated_stats' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef',
	'lazy_build' => 1,
);
sub _build_associated_stats { [] }

=head1 METHODS

Methods called on an instantiated object.

=cut

sub base_ability_mod
{
	my $self  = shift;
	my $score = shift || $self->score;

	my $mod = int( (($score - ( $score % 2 )) - 10) / 2 );
	return $mod;
}

override '_build_modifier' => sub
{
	my $self = shift;

	my $mod  = super();
	   $mod += $self->base_ability_mod;

	return $mod;
};

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_score         { shift->roll_dice("3d6") }
sub _build_display_order { 'explicit' }

sub _build_modifier_of
{
	my $self = shift;

	my %mods = map { +$ARG => sub { shift->apply_modifiers(@ARG) } }
		@{ $self->associated_stats };
	return \%mods;
}

sub apply_modifiers
{
	my $self = shift;
	my($char, $stat, $current_mod) = @ARG;

	return unless $self->is_modifier_of($stat->id);
	return $self->modifier;
}

sub describe_modifiers
{
	my $self = shift;
	my($char, $stat, $current_mod) = @ARG;

	my $stat_id = $stat->id;
	return unless $self->is_modifier_of($stat_id);

	return unless my $mod = $self->modifier;
	return $self->nick . '/' . ( ( $mod < 0 ) ? '-' : '+' ) . abs($mod);
}


sub _add_as_modifying_stat
{
	my($self) = @ARG;

	$self->clear_modifier;

	my $character = $self->character;
	my %modifies  = %{ $self->modifier_of };

	foreach my $modified_id (keys %modifies) {
		my $modified_stat = $character->statistic($modified_id)
			or die "failed to find modified stat with id $modified_id";
		$modified_stat->vivify_modifying_stat($self);
##		$modified_stat->clear_modifier;
##		$modified_stat->clear_modifier_of;
	}

	$self->_update_all_modified_stats;
}

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



