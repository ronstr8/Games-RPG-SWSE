package Games::RPG::SWSE::Feat::ForceSensitivity;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

## Hrm.  "Cannot be a droid."
#sub _build_prerequisites { +{ 'BABBase' => 1 } }

sub _build_description
{
	return <<EOT;

	You are Force-sensitive, allowing you to call on the Force and learn to draw
	on its power.

EOT
}

sub _build_benefit_desc
{
	return <<EOT;

	You can make Use the Force checks, and Use the Force is considered
	a class skill for you. In addition, whenever you gain a new talent,
	you have the option of selecting a Force talent instead. You must
	meet the prerequisites of the Force talent to select it (see
	Force Talents, CORE100).

EOT
}

sub _build_normal_desc
{
	return <<EOT;

	You can't make Use the Force checks (CORE77) or select Force
	talents unless you have the Force Sensitivity feat.

EOT
}


sub _build_special_desc
{
	return <<EOT;

	You can gain this feat multiple times. Each time you take the
	feat, it applies to a different weapon group. You cannot take
	exotic weapons as a weapon group; instead, you must select the
	Exotic Weapon Proficiency feat (see CORE84) to gain proficiency
	with a specific exotic weapon such as the bowcaster or flamethrower.

EOT
}


1;



