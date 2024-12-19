package Games::RPG::SWSE::Feat::LanguageSith;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

## Hrm.  "Cannot be a droid."
#sub _build_prerequisites { +{ 'BABBase' => 1 } }

sub _build_name { 'Sith Language Intuition' };

sub _build_description
{
	return <<EOT;

	You understand the ancient language of the Sith in some intuitive
	way.

EOT
}

sub _build_benefit_desc
{
	return <<EOT;

	You can make Use the Force checks to read (DC10), understand spoken (DC20)
	and communicate spoken (DC20) forms of the Sith language.  You may take 10
	or take 20 when not under duress, and repeat the checks after five minutes.

EOT
}

sub _build_normal_desc
{
	return <<EOT;

	Nobody understands Sith.  Jedi recognize it as such, but cannot (normally)
	understand it or communicate with it.  No knowledge checks can be made;
	one must be peculiarly attuned to some weird aspect of the Force to do so.

EOT
}


sub _build_special_desc
{
	return <<EOT;

	This feat is generally gained only through some plot device.  Even the Sith
	themselves do not necessarily understand this ancient language.

EOT
}


1;




