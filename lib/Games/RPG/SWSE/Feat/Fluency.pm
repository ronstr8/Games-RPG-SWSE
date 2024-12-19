package Games::RPG::SWSE::Feat::Fluency;

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
	return sprintf('You are able to understand spoken %s and speak it fluently.', $self->get_scarg('language'));
}

sub _build_benefit_desc
{
	return <<EOT;

	Choose a language spoken somewhere in the galaxy.  You are now fluent in
	speaking that language and can understand it with a proficiency
	indistinguishable from that of a native speaker.

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

	The ability to speak a language (fluency) does not necessarily confer the
	ability to read/write in that language (literacy).

EOT
}


1;



