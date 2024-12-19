package Games::RPG::SWSE::Equipment;

=head1 NAME

Games::RPG::SWSE::Equipment - Base class for items (weapons, equipment, etc)

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;

use Games::RPG::SWSE::TypeConstraints;

#use Moose::Util::TypeConstraints;
#enum 'SwseSizeCLass'             => [qw( Fine Diminutive Tiny Small Medium Large Huge Gargantuan Colossal )];
#enum 'SwseEquipmentAvailability' => [qw( Unrestricted Licensed Restricted Military Illegal Rare )];
#no Moose::Util::TypeConstraints;

use Moose;
extends qw( Games::RPG::SWSE::Base );

=head1 ATTRIBUTES

Object attributes.

=cut

=head2 size

The size of the object.

=over

=item * Fine (Comlink)

=item * Diminutive (Datapad)

=item * Tiny (Computer)

=item * Small (Storage Bin)

=item * Medium (Desk)

=item * Large (Bed)

=item * Huge (Conference Table)

=item * Gargantuan (Small Bridge)

=item * Colossal (House)

=back

=cut

has 'size' => (
	'is'         => 'rw',
##	'isa'        => 'SwseSizeClass',
	'lazy_build' => 1,
);
sub _build_size { 'Medium' }

has 'size_class' => (
	'is'         => 'rw',
	'isa'        => 'Int',
	'lazy_build' => 1,
);

sub _build_size_class {
	my $self = shift;
	my $size = $self->size;

	my %names_to_classes = (
		'Fine'       => 0,
		'Diminutive' => 1,
		'Tiny'       => 2,
		'Small'      => 3,
		'Medium'     => 4,
		'Large'      => 5,
		'Huge'       => 6,
		'Gargantuan' => 7,
		'Colossal'   => 8,
	);

	## HACK :: Everything should be a size class, not a name.  Dammit.
	return $names_to_classes{$size};
}

=head2 cost

Base cost of the item.

=cut

has 'cost' => (
	'is'         => 'rw',
	'isa'        => 'Number',
	'lazy_build' => 1,
);
sub _build_cost { 0 }

=head2 weight

Weight of item in kilograms.

=cut

has 'weight' => (
	'is'         => 'rw',
	'isa'        => 'Number',
	'lazy_build' => 1,
);
sub _build_weight { 1 }

=head2 availability

The general market availability of the item.

=cut

has 'availability' => (
	'is'         => 'rw',
	'isa'        => 'SwseEquipmentAvailability',
	'lazy_build' => 1,
);
sub _build_availability { 'Unrestricted' }

no Moose; __PACKAGE__->meta->make_immutable;

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




