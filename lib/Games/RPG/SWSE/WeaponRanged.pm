package Games::RPG::SWSE::WeaponRanged;

=head1 NAME

Games::RPG::SWSE::WeaponRanged - An SWSE ranged weapon

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;

use Games::RPG::SWSE::TypeConstraints;

## use Moose::Util::TypeConstraints;
## enum 'SwseWeaponFireRate'    => qw( Single Auto );

use Moose;
extends qw( Games::RPG::SWSE::Weapon );

has 'fire_rate' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[SwseWeaponFireRate]',
	'lazy_build' => 1,
);
sub _build_fire_rate { [qw( Single )] }

has 'range_increments' => (
	'is'                => 'rw',
	'isa'               => 'ArrayRef',
	'lazy_build'        => 1,
);
sub _build_range_increments {
	my $self = shift;
	my $wgrp = $self->weapon_group;

	my %max_ranges_by_group = (
		'Heavy'  => [qw( 0 50 100 250 500 )],
		'Pistol' => [qw( 0 20  40  60  80 )],
		'Rifle'  => [qw( 0 30  60 150 300 )],
		'Simple' => [qw( 0 20  40  60  80 )],
		'Thrown' => [qw( 0  6   8  10  12 )],
	);

	my @ranges = (
		[ 'Zero',         0, 0,    0, [] ],
		[ 'PB',           0, 0,    0, [] ],
		[ 'Short',        0, 0, -  2, [] ],
		[ 'Medium',       0, 0, -  5, [] ],
		[ 'Long',         0, 0, - 10, [] ],
	);

	my $range_inc_ar   = $max_ranges_by_group{$wgrp};
	my $prev_max_range = -1;

	foreach my $rr ( 0 .. $#ranges ) {
		$ranges[$rr][1] = $prev_max_range   +1;
		$ranges[$rr][2] = $prev_max_range = $range_inc_ar->[$rr];
	}

	return \@ranges;
}

no Moose; __PACKAGE__->meta->make_immutable;

=head1 ATTRIBUTES

Object attributes.

=cut

sub _build_usage_stat_id         { 'BABRanged'          }
sub _build_damage_bonus_stat_id  { }
sub _build_size                  { 'Small'        }
sub _build_cost                  {  100           }
sub _build_weight                {  1             }
sub _build_availability          { 'Unrestricted' }
sub _build_weapon_group          { 'Simple'       }

sub _build_damage_type           { 'Energy'   }
sub _build_base_kill_damage_dice { []         }
sub _build_base_stun_damage_dice { []         }

=head1 METHODS

Methods called on an instantiated object.

=cut

sub combat_stats
{
	my $self      = shift;
	my $character = $self->character;

	my $am_name           = $self->name;
	my $am_bab            = $self->base_attack_bonus;
	my $am_dmg_type       = join('/', @{ $self->damage_type });
	my $half_level_bonus  = $self->heroic_level_damage_dice;

	my @base_kill_dmg_dice    = @{ $self->base_kill_damage_dice || [] };
	my @base_stun_dmg_dice    = @{ $self->base_stun_damage_dice || [] };
	my @ranged_kill_dmg_dice  = ( @base_kill_dmg_dice, $half_level_bonus );

	my $base_kill_dmg_dice_desc = $self->describe_dice(@base_kill_dmg_dice);
	my $base_stun_dmg_dice_desc = $self->describe_dice(@base_stun_dmg_dice);
	   $base_stun_dmg_dice_desc = $base_stun_dmg_dice_desc && ( $base_stun_dmg_dice_desc ne $base_kill_dmg_dice_desc )
		? " (Stun $base_stun_dmg_dice_desc)" : '';

	my $base_damage_desc = sprintf('Base %s%s %s (+HL/2[%s])',
			$base_kill_dmg_dice_desc,
			$base_stun_dmg_dice_desc,
			$am_dmg_type,
			$half_level_bonus,
	);

	my @range_increments = @{ $self->range_increments };
	my @all_ranges       = map { $ARG->[0] } @range_increments;

	my $is_shooter = $self->weapon_group !~ m/Simple|Thrown/;
	my %variants;
	my %varmods;

	## HACK :: Need to integrate these into the feats themselves?
	my $has_point_blank = $character->statistic('FeatPointBlankShot');
	if ($has_point_blank) {
		foreach my $range (qw( Zero PB )) {
			my $mod_ar = $varmods{'Normal'}{$range} ||= [];
			$mod_ar->[0] += 1;
			push @{ $mod_ar }, '+1';
		}
	}

	my $has_zero_range = $character->statistic('FeatZeroRange');
	if ($has_zero_range) {
		foreach my $range (qw( Zero )) {
			my $mod_ar = $varmods{'Normal'}{$range} ||= [];
			$mod_ar->[0] += 1;
			push @{ $mod_ar }, '+1d';
		}
	}

	my $has_rapid_shot   = $is_shooter && $character->statistic('FeatRapidShot');
	my $has_trigger_work = $is_shooter && $character->statistic('TalentTriggerWork');

	if ($has_rapid_shot) {
		## NOTE :: Penalty should be -5 with STR<=13 and non-vehicle weapons.
		my $bab_mod = $has_trigger_work ? 0 : -2;
		my $dmg_mod = '+1d';

		foreach my $range (@all_ranges) {
			my @variant_mod  = ( @{ $varmods{'Normal'}{$range} || [] } );

			if (not($has_zero_range) or ($range ne 'Zero')) {
				$variant_mod[0] += $bab_mod;
				push @variant_mod, $dmg_mod;
			}

			$varmods{'Rapid Shot'}{$range} = \@variant_mod;
		}

		if ($has_trigger_work) {
			delete $varmods{'Normal'};
			delete $variants{'Normal'};
		}
	}

##	use Quack; quack { \%varmods };

	my @modes;

	foreach my $range_inc_ar (@range_increments) {
		my($name, $min, $max, $bab_modifier, $dmg_modifiers_ar) = @{ $range_inc_ar };
		my @dmg_modifiers = @{ $dmg_modifiers_ar };

		my $bab_modded = $am_bab + $bab_modifier;
		my $dmg_modded = $self->describe_dice(@ranged_kill_dmg_dice, @dmg_modifiers);

		my $mod_desc  = $bab_modifier ?
			sprintf('%s%d', $bab_modifier < 0 ? '-' : '+', abs($bab_modifier)) : '';
##		my $mod_desc  = sprintf('%s%d', $am_bab < 0 ? '-' : '+', abs($am_bab));
##		   $mod_desc .= sprintf(' / %s', join(' + ', @dmg_modifiers)) if @dmg_modifiers;
##		   $mod_desc .= sprintf(' / %s', $self->describe_dice(@dmg_modifiers)) if @dmg_modifiers;

		my $range_desc = $min ? ( $max ? "${min}-${max}" : "${min}+" ) : ( $max ? "-${max}" : '' );
		my $range_note = $range_desc ? ( $mod_desc ? "$range_desc / $mod_desc" : $range_desc )
			: ( $mod_desc ? $mod_desc : '' );
		$range_note = ": $range_note" if $range_note;
		push @modes, "$name$range_note";

##		push @{ $variants{'Normal'} }, [ $bab_modded, $dmg_modded ];

		while (my($variant, $mods_hr) = each(%varmods)) {
			my $var_bab_modded = $bab_modded;
			my $var_dmg_modded = $dmg_modded;
			my @mods_ar        = @{ $mods_hr->{$name} || [] };

##			use Quack; quack { $variant, $name, \@mods_ar, $var_bab_modded, $var_dmg_modded };

			if (@mods_ar) {
				my($var_bab_mod, @var_dmg_mod) = @mods_ar;
				$var_bab_modded += $var_bab_mod;
				$var_dmg_modded  = $self->describe_dice($var_dmg_modded, @var_dmg_mod);
			}
			push @{ $variants{$variant} }, [ $var_bab_modded, $var_dmg_modded ];
		}
	}

	my @variants;
	push @variants, ( [ 'Normal' => delete $variants{'Normal'} ] ) if $variants{'Normal'};
	push @variants, [ $ARG => $variants{$ARG} ] for keys %variants;

	my %stats = (
		'name'             => $am_name,
		'notes'            => $self->combat_notes,
		'base_damage_desc' => $base_damage_desc,
		'modes'            => \@modes,
		'variants'         => \@variants,
	);

	return %stats;
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



