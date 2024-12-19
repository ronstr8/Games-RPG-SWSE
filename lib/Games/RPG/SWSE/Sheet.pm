package Games::RPG::SWSE::Sheet;

=head1 NAME

Games::RPG::SWSE::Sheet - Generic gameplay aid template/renderer

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;
use HTML::Mason::Interp;

use Moose;
extends qw( Games::RPG::SWSE::Base );

=head1 ATTRIBUTES

Object attributes.

=cut

has 'variables' => (
	'is'         => 'rw',
	'isa'        => 'HashRef',
	'default'    => sub { +{} },
);

has 'template' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);

has 'rendered' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);

has [qw( content )] => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);

has '_scratch' => (
	'is'         => 'rw',
	'isa'        => 'ScalarRef',
	'default'    => sub { my $foo = ""; return \$foo; },
);

has '_component' => (
	'is'         => 'rw',
	'isa'        => 'HTML::Mason::Component',
	'lazy_build' => 1,
);

has '_interpreter' => (
	'is'         => 'rw',
	'isa'        => 'HTML::Mason::Interp',
	'lazy_build' => 1,
);


no Moose; __PACKAGE__->meta->make_immutable;

sub _build_content
{
	return '';
}

sub _build_template
{
	return <<'EOT';

<% $sheet->content %>

<%args>
	$sheet
</%args>
EOT
}

sub _build__interpreter
{
	my $self = shift;
	return HTML::Mason::Interp->new('out_method' => $self->_scratch);
}

sub _build__component
{
	my $self = shift;

	my %mcargs = (
		'comp_source' => $self->template,
		'name'        => __FILE__,
	);
	return $self->_interpreter->make_component(%mcargs);
}

sub _build_rendered
{
	my $self = shift;

	my %eargs = (
		'sheet' => $self,
		%{ $self->variables },
	);
	$self->_interpreter->exec($self->_component, %eargs);

	return ${ $self->_scratch };
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



