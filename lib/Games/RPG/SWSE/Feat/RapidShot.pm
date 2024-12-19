package Games::RPG::SWSE::Feat::RapidShot;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_description
{
	return <<EOT;

	You can make two quick shots with a ranged weapon as a single attack.

EOT
}

sub _build_prerequisites { +{ 'BABBase' => 1 } }

sub _build_benefit_desc
{
	return <<EOT;

	When using a ranged weapon, you may fire two shots as a single attack
	against a single target.  You take a -2 penalty on your attack roll,
	but you deal +1 die of damage with a successful attack.

EOT
}

sub _build_special_desc
{
	return <<EOT;

	Using this feat requires two shots and can only be done if the weapon has
	sufficient ammunition remaining.  The effects of this feat do not stack
	with the extra damage provided by the Burst Fire feat (CORE82) or Deadeye
	feat (CORE84).  If you do not have a Strength of 13 or higher, increase the
	penalty to attacks to -5 when using this feat with non-vehicle weapons.

EOT
}


1;


