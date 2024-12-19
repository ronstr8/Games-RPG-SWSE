package Games::RPG::SWSE::CharacterAspect;

=head1 NAME

Games::RPG::SWSE::CharacterAspect - Some aspect (feat, trait, skill) of an SWSE character

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;
use List::Util;

use Moose;
extends 'Games::RPG::SWSE::Base';

=head1 ATTRIBUTES

Object attributes.

=cut


=head2 prerequisites

=cut

has 'prerequisites' =>
(
	'is'         => 'rw',
	'isa'        => 'HashRef',
	'lazy_build' => 1,
);
sub _build_prerequisites { +{} }

=head2 blurb_desc

Most concise description of the aspect.

=cut

has 'blurb_desc' =>
(
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_blurb_desc { '' }

=head2 benefit_desc

=cut

has 'benefit_desc' =>
(
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_benefit_desc { '' }

=head2 special_desc

=cut

has 'special_desc' =>
(
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_special_desc { '' }

=head2 normal_desc

=cut

has 'normal_desc' =>
(
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_normal_desc { '' }

=head2 aspect_type

=cut

has 'aspect_type' =>
(
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_aspect_type { my $id = ref(shift); my @id = split(/::/, $id); $id[-2]; }


no Moose; __PACKAGE__->meta->make_immutable;

sub _build__level_or_rank { 1 }

=head1 METHODS

Methods called on an instantiated object.

=cut

=head2 as_text_blurb ( Games::RPG::SWSE::Character )

A short text blurb describing the game statistic as applied to the given
character.

=cut

sub as_text_blurb
{
	my($self, $char) = @ARG;

	## HACK :: Below should use polymorphism for some "subtype"
	## or other specificity of a feat, trait, or other perk-like
	## facet of the character.

	my $subtype = '';

	foreach my $scarg (qw( group ability skill language )) {
		last if $subtype = eval { $self->$scarg } || eval { $self->get_scarg($scarg) };
	}

	my $title = sprintf('%s: %s%s',
		$self->aspect_type,
		$self->name,
		$subtype ? " ($subtype)" : '',
	);

	my $desc = $self->blurb_desc || $self->benefit_desc || $self->description || '';
	$desc =~ s/^\s+//;
	$desc =~ s/\s+$//;
	$desc =~ s/^(\S)/\t$1/gs if $desc;

	my $output  = $title;
	   $output .= "\n$desc\n" if $desc;

	return $output;
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



