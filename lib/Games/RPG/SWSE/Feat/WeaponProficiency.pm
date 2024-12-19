package Games::RPG::SWSE::Feat::WeaponProficiency;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Feat );
no Moose; __PACKAGE__->meta->make_immutable;

sub _build_prerequisites { +{ 'BABBase' => 1 } }

sub _build_blurb_desc { shift->description }

sub _build_description
{
	my $self  = shift;

	return sprintf('You are proficient in the use of weapons of the "%s" type.',
		$self->get_scarg('group'));
}


## sub _build_description { 'You are proficient with a particular kind of weaponry.' }

sub _build_benefit_desc
{
	return <<EOT;

	Choose one of the following weapon groups: advanced melee
	weapons, heavy weapons (which includes vehicular weapons and starship
	weapons, lightsabers, pistols, rifles, and simple weapons. You are
	proficient with all weapons of the selected group. For more information
	on weapon groups, see CORE119.

EOT
}

sub _build_normal_desc
{
	return <<EOT;

	If you wield a weapon with which you are not proficient. you
	take a -5 penalty to your attack rolls.

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



