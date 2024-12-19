package Games::RPG::SWSE::Feat::Literacy;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_blurb_desc { shift->description }

sub _build_description
{
	my $self = shift;
	return sprintf('You can read and write %s.', $self->get_scarg('language'));
}

sub _build_benefit_desc
{
	return <<EOT;

	Choose some language used to communicate somewhere in the galaxy.  You are
	now able to participate in written communication in that language.
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

	The character may not be able to speak the language due to brain trauma or
	mental disability, some physical restriction (e.g. not having the vocal
	organs required), etc.

EOT
}


1;



