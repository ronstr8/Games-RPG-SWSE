package Games::RPG::SWSE::Skill;

=head1 NAME

lib/Games/RPG/SWSE/Skill/Skill.pm - An SWSE Skill

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;
use List::Util();

use Moose;
extends qw( Games::RPG::SWSE::Base );

=head1 ATTRIBUTES

Object attributes.

=cut

=head2 trained

True if trained in this skill.

=cut

has 'trained' => (
	'is'         => 'rw',
	'isa'        => 'Bool',
	'lazy_build' => 1,
);
sub _build_trained { 0 }

=head2 focused

True if skill focus was chosen for this skill.

=cut

has 'focused' => (
	'is'         => 'rw',
	'isa'        => 'Bool',
	'lazy_build' => 1,
);
sub _build_focused { 0 }

=head2 mastered

True if skill mastery was chosen for this skill.

=cut

has 'mastered' => (
	'is'         => 'rw',
	'isa'        => 'Bool',
	'lazy_build' => 1,
);
sub _build_mastered { 0 }


=head2 has_armor_check_penalty

True if a penalty should be applied when using the skill while wearing armor in
which one is not proficient.

=cut

has 'has_armor_check_penalty' =>
(
	'is'         => 'rw',
	'isa'        => 'Bool',
	'lazy_build' => 1,
);
sub _build_has_armor_check_penalty { 0 }

=head2 can_use_untrained

True if one can use the skill without being trained in it.

=cut

has 'can_use_untrained' =>
(
	'is'         => 'rw',
	'isa'        => 'Bool',
	'lazy_build' => 1,
);
sub _build_can_use_untrained { 0 }


=head2 use_ids

Array ref of skill use identifiers associated with the skill.

=cut

has 'use_ids' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef',
	'lazy_build' => 1,
);
sub _use_ids { +[] }

=head1 METHODS

Methods called on an instantiated object.

=cut

override '_build_modifier' => sub
{
	my($self) = @ARG;

	my $character = $self->character;

	my $mod = super();
	$self->_debug(sprintf('%s->super() [$mod=%d]', $self->id, $mod));

	$mod += ( $self->trained * 5 );
	$self->_debug(sprintf('%s->trained? %s [$mod=%d]', $self->id, $self->trained ? 'Yes' : 'No', $mod));

	$mod += ( $self->focused * 5 );
	$self->_debug(sprintf('%s->focused? %s [$mod=%d]', $self->id, $self->focused ? 'Yes' : 'No', $mod));
	
	$mod += ( $self->mastered * 5 );
	$self->_debug(sprintf('%s->mastered? %s [$mod=%d]', $self->id, $self->mastered ? 'Yes' : 'No', $mod));


	return $mod;
};

no Moose; __PACKAGE__->meta->make_immutable;

=head2 score_as_text_blurb

Return a string containing C<T> if the character is trained in, and an C<F> if
he has taken a skill focus in this skill.

=cut

sub score_as_text_blurb
{
	my $self = shift;
	my $char = $self->character;

	return ' ' .
		( $self->trained  ? 'T' : ' ' ) .
		( $self->focused  ? 'F' : ' ' ) .
		( $self->mastered ? 'M' : ' ' )
	;
}


sub governing_attribute
{
	my $self = shift;
	my $id   = $self->id;
	my $char = $self->character;

	List::Util::first { $ARG->is_modifier_of($id) } ( @{ $char->abilities } );
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



