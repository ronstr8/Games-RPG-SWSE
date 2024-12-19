package Games::RPG::SWSE::Defense;

=head1 NAME

Games::RPG::SWSE::Defense - An SWSE defense stat

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

override '_build_modifier' => sub
{
	return super() + 10;
};


=head1 METHODS

Methods called on an instantiated object.

=cut

no Moose; __PACKAGE__->meta->make_immutable;

sub score_as_text_blurb { return sprintf('%3.3s', 10) }

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



