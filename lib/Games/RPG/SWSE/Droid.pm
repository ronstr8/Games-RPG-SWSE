package Games::RPG::SWSE::Droid;

=head1 NAME

Games::RPG::SWSE::Droid - An SWSE droid

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;

use Moose;
extends qw(
	Games::RPG::SWSE::Character
	Games::RPG::SWSE::Equipment
);

=head1 ATTRIBUTES

Object attributes.

=cut

has '_modifiers_by_size' => (
	'is'         => 'rw',
	'isa'        => 'HashRef',
	'traits'     => [qw( Hash )],
	'handles'    => {
			'droid_size_modifiers'     => [qw( get )],
		},
	'lazy_build' => 1,
);
sub _build__modifiers_by_size
{
	my %mods = (
		'Colossal' => {
				'AbilitySTR'              =>  32,
				'AbilityDEX'              =>  -4,
				'DefenseREF'              => -10,
				'SkillStealth'            => -20,
				'PhysicalHitPoints'       => 100,
			},
		'Gargantuan' => {
				'AbilitySTR'              =>  24,
				'AbilityDEX'              =>  -4,
				'DefenseREF'              =>  -5,
				'SkillStealth'            => -15,
				'PhysicalHitPoints'       =>  50,
			},
		'Huge' => {
				'AbilitySTR'              =>  16,
				'AbilityDEX'              =>  -4,
				'DefenseREF'              =>  -2,
				'SkillStealth'            => -10,
				'PhysicalHitPoints'       =>  20,
			},
		'Large' => {
				'AbilitySTR'              =>   8,
				'AbilityDEX'              =>  -2,
				'DefenseREF'              =>  -1,
				'SkillStealth'            =>  -5,
				'PhysicalHitPoints'       =>  10,
			},
		'Medium' => {
			},
		'Small' => {
				'AbilitySTR'              =>  -2,
				'AbilityDEX'              =>  +2,
				'DefenseREF'              =>  +1,
				'SkillStealth'            =>  +5,
			},
		'Tiny' => {
				'AbilitySTR'              =>  -4,
				'AbilityDEX'              =>   4,
				'DefenseREF'              =>   2,
				'SkillStealth'            =>  10,
			},
		'Diminutive' => {
				'AbilitySTR'              =>  -6,
				'AbilityDEX'              =>   6,
				'DefenseREF'              =>   5,
				'SkillStealth'            =>  15,
			},
		'Fine' => {
				'AbilitySTR'              =>   8,
				'AbilityDEX'              =>  -8,
				'DefenseREF'              =>  10,
				'SkillStealth'            =>  20,
			},
	);

	return \%mods;
}

has '_attributes_by_droid_size' => (
	'is'         => 'rw',
	'isa'        => 'HashRef',
	'traits'     => [qw( Hash )],
	'handles'    => {
			'default_damage_threshold_mod'     => [qw( get damage_threshold_mod    )],
			'default_carrying_capacity_mult'   => [qw( get carrying_capacity_mult  )],
			'default_droid_cost_factor'        => [qw( get droid_cost_factor       )],
			'default_accessory_weight_cf_mod'  => [qw( get accessory_weight_cf_mod )],
		},
	'lazy_build' => 1,
);
sub _build__attributes_by_droid_size
{
	my %mods = (
		'Colossal' => {
				'damage_threshold_mod'    =>  32,
				'carrying_capacity_mult'  =>  20,
				'droid_cost_factor'             =>  20,
				'accessory_weight_cf_mod' =>  20,
			},
		'Gargantuan' => {
				'damage_threshold_mod'    =>  20,
				'carrying_capacity_mult'  =>  10,
				'droid_cost_factor'             =>  10,
				'accessory_weight_cf_mod' =>  10,
			},
		'Huge' => {
				'damage_threshold_mod'    =>  10,
				'carrying_capacity_mult'  =>   5,
				'droid_cost_factor'             =>   5,
				'accessory_weight_cf_mod' =>   5,
			},
		'Large' => {
				'damage_threshold_mod'    =>   5,
				'carrying_capacity_mult'  =>   2,
				'droid_cost_factor'             =>   2,
				'accessory_weight_cf_mod' =>   2,
			},
		'Medium' => {
				'damage_threshold_mod'    =>   0,
				'carrying_capacity_mult'  =>   1,
				'droid_cost_factor'             =>   1,
				'accessory_weight_cf_mod' =>   1,
			},
		'Small' => {
				'damage_threshold_mod'    =>    0,
				'carrying_capacity_mult'  => 0.75,
				'droid_cost_factor'             =>    2,
				'accessory_weight_cf_mod' =>    1,  ## <=Small: 2/CF
			},
		'Tiny' => {
				'damage_threshold_mod'    =>    0,
				'carrying_capacity_mult'  => 0.50,
				'droid_cost_factor'             =>    5,
				'accessory_weight_cf_mod' =>  0.4,  ## <=Small: 2/CF
			},
		'Diminutive' => {
				'damage_threshold_mod'    =>    0,
				'carrying_capacity_mult'  => 0.25,
				'droid_cost_factor'             =>   10,
				'accessory_weight_cf_mod' =>  0.2,  ## <=Small: 2/CF
			},
		'Fine' => {
				'damage_threshold_mod'    =>    0,
				'carrying_capacity_mult'  => 0.01,
				'droid_cost_factor'             =>   20,
				'accessory_weight_cf_mod' =>  0.1,  ## <=Small: 2/CF
			},
	);

	return \%mods;
}

has 'droid_cost_factor' => (
	'is'         => 'rw',
	'isa'        => 'Int',
	'lazy_build' => 1,
);
sub _build_droid_cost_factor
{
	my $self = shift;

}

has 'droid_degree' => (
	'is'         => 'rw',
	'isa'        => 'Int',
	'required'   => 1,
	'lazy_build' => 1,
);
sub _build_droid_degree { }

##has '+size' => ( 'required' => 1 );

has 'droid_degree_name' => (
	'is'         => 'rw',
	'isa'        => 'Maybe[Int]',
	'lazy_build' => 1,
);
sub _build_droid_degree_name
{
	my $self   = shift;
	my $degree = $self->droid_degree;

	my %names = (
		1 => '1st Degree - Medical/Scientific',
		2 => '2nd Degree - Astromech/Technical',
		3 => '3rd Degree - Protocol/Service',
		4 => '4th Degree - Combat/Security',
		5 => '5th Degree - Labor/Utility',
	);

	return $names{$degree};
}

sub _build_cost { 0 }

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_modifier_of
{
	my $self  = shift;

	my %mods = ( %{ $self->droid_size_modifiers( $self->size ) } );
	return \%mods;
}

=head2 describe_modifiers ( Games::RPG::SWSE::Character, Games::RPG::SWSE::Base, $current_mod )

Return a description of the modifier explained above.

=cut

sub describe_modifiers
{
	my $self = shift;
	my($char, $stat, $current_mod) = @ARG;

	my $stat_id = $stat->id;
	return unless $self->is_modifier_of($stat_id);

	my $size = $self->size;
	my $nick = $self->nick . '/' . $size;

	my $mod;

	my $size_mods_hr = $self->droid_size_mods($size);
	$mod = $size_mods_hr->{$stat_id};

	return unless $mod;
	return $self->nick . '/' . ( ( $mod < 0 ) ? '-' : '+' ) . abs($mod);
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




