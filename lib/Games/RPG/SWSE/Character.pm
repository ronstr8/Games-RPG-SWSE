package Games::RPG::SWSE::Character;

=head1 NAME

Games::RPG::SWSE::Character - A SWSE character

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;
use List::Util;
use UNIVERSAL::require;

use Moose;
extends qw( Games::RPG::SWSE::Base );

=head1 ATTRIBUTES

Object attributes.

=cut

=head2 verbosity ( $level )

Used for various debugging routines.

=cut

has 'verbosity' => (
	'is'         => 'rw',
	'isa'        => 'Int',
	'lazy_build' => 1,
);
sub _build_verbosity { 0 }

=head2 base_class_instance ( Class->id )

Return a cached instance of the base class with the given id.

=cut

has '_base_class_instances' => (
	'is'         => 'rw',
	'isa'        => 'HashRef',
	'traits'     => [qw( Hash )],
	'handles'    => {
			'base_class_instance' => 'get',
		},
	'lazy_build' => 1,
);
sub _build__base_class_instances
{
	my $self = shift;

	my %base_classes = map { $ARG => "Games::RPG::SWSE::$ARG" }
		qw( Race Ability Skill Class Defense Feat Talent BAB Equipment Physical );

	my %base_class_args = (
		'Class' => +{ 'heroic_level' => 0 },
	);
	my %base_class_instances;

	while (my($id, $pkg) = each(%base_classes)) {
		$pkg->use
			or die "failed to use base class $pkg: $EVAL_ERROR";

		my $cargs_hr = $base_class_args{$id};
		my %cargs    = $cargs_hr ? %{ $cargs_hr } : ();
		$base_class_instances{$id} = $pkg->new('character' => $self, %cargs);
	}

	return \%base_class_instances;
}

has '_statistics_by_id' => (
	'is'         => 'rw',
	'isa'        => 'HashRef',
	'traits'     => [qw( Hash )],
	'handles'    => {
			'statistic'     => [qw( get )],
			'statistics'    => 'values',
			'statistic_ids' => 'keys',
		},
	'lazy_build' => 1,
);
sub _build__statistics_by_id
{
	my $self = shift;

	my @statistics = (
		@{ $self->abilities           },
		@{ $self->defenses            },
		@{ $self->skills              },
		@{ $self->feats               },
		@{ $self->talents             },
		@{ $self->classes             },
		@{ $self->attack_bonuses      },
		@{ $self->_equipment          },
		@{ $self->physicals           },
	);
	$self->_map_list_by_id(\@statistics);
}

sub _stat_by_type_and_nid
{
	my($self, $type, $nid) = @ARG;

	Carp::confess("no $nid for $type in $self") unless $nid;
	$nid = "$type$nid" unless $nid =~ /^$type/;
	return $self->statistic($nid);
}
sub ability   { shift->_stat_by_type_and_nid('Ability',   shift) }
sub skill     { shift->_stat_by_type_and_nid('Skill',     shift) }
sub class     { shift->_stat_by_type_and_nid('Class',     shift) }
sub defense   { shift->_stat_by_type_and_nid('Defense',   shift) }
sub BAB       { shift->_stat_by_type_and_nid('BAB',       shift) }
sub feat      { shift->_stat_by_type_and_nid('Feat',      shift) }
sub talent    { shift->_stat_by_type_and_nid('Talent',    shift) }
sub equipment { shift->_stat_by_type_and_nid('Equipment', shift) }

=head2 size_class

The size class of the character.

=over

=item * 0 - Fine (Comlink)

=item * 1 - Diminutive (Datapad)

=item * 2 - Tiny (Computer)

=item * 3 - Small (Storage Bin)

=item * 4 - Medium (Desk)

=item * 5 - Large (Bed)

=item * 6 - Huge (Conference Table)

=item * 7 - Gargantuan (Small Bridge)

=item * 8 - Colossal (House)

=back

=cut

has 'size_class' => (
	'is'         => 'rw',
	'isa'        => 'Int',
	'lazy_build' => 1,
);
sub _build_size_class { 4 }

=head2 abilities

Objects representing each SWSE ability, with the character's score.

=cut

has 'abilities' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[Games::RPG::SWSE::Ability]',
	'traits'     => [qw( Array )],
	'lazy_build' => 1,
);
sub _build_abilities { shift->base_class_instance('Ability')->all_subclass_kids }

=head2 physicals

Objects representing some physical attribute of the character, such as movement
speed.

=cut

has 'physicals' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[Games::RPG::SWSE::Physical]',
	'traits'     => [qw( Array )],
	'lazy_build' => 1,
);
sub _build_physicals { shift->base_class_instance('Physical')->all_subclass_kids }

=head2 skills

Objects representing each SWSE ability, with the character's score.

=cut

has 'skills' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[Games::RPG::SWSE::Skill]',
	'lazy_build' => 1,
);
sub _build_skills { shift->base_class_instance('Skill')->all_subclass_kids }

=head2 classes

Objects representing all classes chosen by the character, with his level in
each.

=cut

has 'classes' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[Games::RPG::SWSE::Class]',
	'trigger'    => sub { shift->_clear_statistics_by_id },
	'traits'     => [qw( Array )],
	'handles'    => {
			'push_class'    => [qw( push   )],
			'current_class' => [qw( get -1 )],
			'heroic_level'  => 'count',
## 								[ 'reduce', sub {
## 					my($sofar, $next) = @ARG;
## 					$sofar  = ( ref($sofar) ? $sofar->level : $sofar );
## 					$sofar += ( ref($next)  ? $next->level  : 0      );
## 					use Quack; quack { ref($sofar) ? ref($sofar) : $sofar, ref($next) ? ref($next) : $next };
## 					$sofar;
## 				}],
## 			'hit_points'  => [ 'reduce', sub {
## 					my $bonus = $self->ability_modifier('CON') || 0;
## 					my($sofar, $next) = @ARG;
## 					$sofar  = ref($sofar) ? $sofar->hit_points : $sofar;
## 					$sofar += ref($next)  ? $next->hit_points  : 0;
## 					$sofar || 0;
## 				}],
			'unique_classes'  => [ 'reduce', sub {
					my($sofar, $next) = @ARG;
					$sofar = (ref($sofar) and (ref($sofar) eq 'ARRAY')) ? $sofar : [$sofar];
					push @{ $sofar }, $next unless grep { $ARG->id eq $next->id } @{ $sofar };
					$sofar || [];
				}],
			'grep_classes' => 'grep',
		},
	'lazy_build' => 1,
);
sub _build_classes { [] }

sub hit_points
{
	my $self  = shift;
	my $bonus = $self->ability_modifier('CON') || 0;

	my $hp = 0;

	foreach my $class (( @{ $self->classes } )) {
		$hp += $class->hit_points + $bonus;
	}

	return $hp;
};

## TODO :: DT, DR, and SR all need better implementation as
## proper charistics usable with the interactive mod system,
## e.g. so that armor can add its bonus to DT.
## sub damage_threshold
## {
## 	my $self  = shift;
## 	my $bonus = $self->defense('FORT')->modifier || 0;
## 	return "$bonus (+ArmorBonus)";
## }
## sub shield_rating    { my $self  = shift; return 'TBI'; }
## sub damage_reduction { my $self  = shift; return 'TBI'; }
## 

sub levels_in_class
{
	my($self, $id) = @ARG;
	return $self->grep_classes( sub { $ARG->id eq $id } );
};

=head2 defenses

Objects representing the three primary defense scores of the character.

=cut

has 'defenses' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[Games::RPG::SWSE::Defense]',
	'trigger'    => sub { shift->_clear_statistics_by_id },
	'lazy_build' => 1,
);
sub _build_defenses { shift->base_class_instance('Defense')->all_subclass_kids }

=head2 attack_bonuses

Objects representing the attack bonuses for the character.

=cut

has 'attack_bonuses' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[Games::RPG::SWSE::BAB]',
	'trigger'    => sub { shift->_clear_statistics_by_id },
	'lazy_build' => 1,
);
sub _build_attack_bonuses { shift->base_class_instance('BAB')->all_subclass_kids }


=head2 feats

Objects representing all feats chosen by the character.

=cut

has 'feats' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[Games::RPG::SWSE::Feat]',
	'trigger'    => sub { shift->_clear_statistics_by_id },
	'traits'     => [qw( Array )],
	'handles'    => {
			'push_feat' => 'push',
		},
	'lazy_build' => 1,
);
sub _build_feats { [] }

=head2 talents

Objects representing all talents chosen by the character.

=cut

has 'talents' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[Games::RPG::SWSE::Talent]',
	'trigger'    => sub { shift->_clear_statistics_by_id },
	'traits'     => [qw( Array )],
	'handles'    => {
			'push_talent' => 'push',
		},
	'lazy_build' => 1,
);
sub _build_talents { [] }

=head2 equipment

Objects representing all items worn or wielded by the character.

=cut

has '_equipment' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef[Games::RPG::SWSE::Equipment]',
	'trigger'    => sub { shift->_clear_statistics_by_id },
	'traits'     => [qw( Array )],
	'handles'    => {
			'push_equipment' => 'push',
		},
	'lazy_build' => 1,
);
sub _build__equipment { [] }

no Moose; __PACKAGE__->meta->make_immutable;

=head1 METHODS

Methods called on an instantiated object.

=cut

=head2 add_class ( Games::RPG::SWSE::Class->id )

Add a level in this class to the character.  Each level of a class has its own
insantiation of the class object, with the order being important at least
inasmuch as the last is the character's current class.

Returns the newly added class, so that you can set various things upon it if
desired.

=cut

sub add_class
{
	my $self = shift;

	my $class = $self->_add_stat_by_type_and_nid('Class', @ARG, 'new' => 1, 'level' => 1);
 	$self->clear_modifier_of;

	return $class;
}

=head2 add_feat ( Games::RPG::SWSE::Feat->id, %scargs )

Add a feat to the character.  The C<%scargs> are passed as the
L<Games::RPG::SWSE::Base/scargs> value for the feat, except for the following,
deleted and interpreted first:

=over

=item * new - If true, force creation of a new feat, even if one already exists

=back

That's all.

=cut

sub _add_stat_by_type_and_nid
{
	my($self, $stat_type, $nid, %options) = @ARG;

	my $getter    = lc($stat_type);
	my $pusher    = "push_$getter";
	my $force_new = delete $options{'new'};

	my $id = $nid;
	   $id = "$stat_type$id" unless $id =~ /^$stat_type/;

	my $nick =  $nid;
	   $nick =~ s/^$stat_type//;

	my $is_new_stat = 0;
	my $stat        = $force_new ? undef : $self->$getter($nick);

	if (not $stat) {
		$is_new_stat = 1;
		my $subclass = $self->base_class_instance($stat_type)->subclass($nick)
			or die "failed to determine subclass for $stat_type $nick";
		$stat = $subclass->new('character' => $self, %options);
	}

	my $rank = delete $options{'rank'} // delete $options{'level'};

	$stat->scargs(\%options);

	my $current_rank = $stat->rank;
	my $new_rank     = defined($rank) ? $rank : $current_rank + 1;
	$stat->rank($new_rank);

	my %modified_stats;

	foreach my $changed_stat ($stat, $self) {
		$changed_stat->clear_modifier_of;
		my %modifies = %{ $changed_stat->modifier_of };

		foreach my $modified_id (keys %modifies) {
			my $modified_stat = $self->statistic($modified_id)
				or die "failed to find modified stat with id $modified_id";
			$modified_stat->add_modifying_stat($stat);
			$modified_stats{$modified_id} = $modified_stat;
		}
	}

##	$ARG->clear_modifier for values %modified_stats;

	$self->$pusher($stat) if $is_new_stat;
	return $stat;
}

sub add_feat { shift->_add_stat_by_type_and_nid('Feat', @ARG) }

=head2 add_talent ( Games::RPG::SWSE::Talent->id, %options )

Add a talent to the character.

=cut

sub add_talent { shift->_add_stat_by_type_and_nid('Talent', @ARG) }

=head2 add_equipment ( Games::RPG::SWSE::Equipment->id )

Adds something either worn or wielded by the character.

=cut

sub add_equipment { shift->_add_stat_by_type_and_nid('Equipment', @ARG) }


=head2 base_attack_bonus

The sum of attack bonuses for all classes this character has selected.

=cut

sub base_attack_bonus
{
	my $self = shift;

	my $bab = 0;

	foreach my $class (( @{ $self->unique_classes || [] } )) {
		my $class_bab = $class->base_attack_bonus;
		$bab += $class_bab;
	}

	return $bab;
}

=head2 heroic_level

The total of all levels achieved in all classes this character has selected.

=cut

=head2 ability_modifier ( Games::RPG::SWSE::Ability->id )

The modifier for the given ability.

=cut

sub ability_modifier
{
	my($self, $id) = @ARG;

	my $ability = $self->ability($id)
		or die "failed to find ability with the given id $id";

	return $ability->modifier;
}

=head2 max_class_defense_bonus ( @Games::RPG::SWSE::Defense->id )

The maximum bonus for the given defense bestowed by any of the classes in which
this character has levels.

In list context, return a hash with keys of C<nick> and C<mod> and values of
the class nick and its modifier.

If multiple id are given, always return a hash keyed on the defense-id with
values consisting of a hash-ref of C<nick> and C<mod> as per above.

=cut

sub max_class_defense_bonus
{
	my($self, @ids) = @ARG;

	my %max = map { $ARG => { 'nick' => '', 'mod' => 0 } } @ids;

	foreach my $class ((@{ $self->classes })) {
		foreach my $defense_id (@ids) {
			my $class_mod = $class->defense_bonus($defense_id);
			next unless $class_mod > $max{$defense_id}{'mod'};

			$max{$defense_id}{'mod'}  = $class_mod;
			$max{$defense_id}{'nick'} = $class->nick;
		}
	}

	if (@ids == 1) {
		%max = %{ $max{$ids[0]} } if @ids == 1;
		return wantarray ? %max : $max{'mod'};
	}

	return %max;
}

=head2 max_class_defense_bonuses

The maximum bonus for the all defenses bestowed by any of the classes in which
this character has levels.

In list context, return a hash with keys of C<nick> and C<mod> and values of
the class nick and its modifier.

=cut

sub max_class_defense_bonuses
{
	my $self = shift;
	my @ids  = map { $ARG->id } ( @{ $self->defenses } );

	return $self->max_class_defense_bonus(@ids);
}

sub _build_modifier_of
{
	my $self  = shift;

	my %mods;
	my $hl_full = $self->heroic_level;
	my $hl_half = int($hl_full / 2);

	$mods{$ARG->id} = $hl_half for (@{ $self->skills });

	my %bonuses_by_defense_id = $self->max_class_defense_bonuses;

	while (my($defense_id, $mod_hr) = each(%bonuses_by_defense_id)) {
		$mods{$defense_id} = $hl_full + $mod_hr->{'mod'};
	}
##	$mods{$ARG->id} = $hl_full + $self->max_class_defense_bonus($ARG->id) for (@{ $self->defenses });

##	use Quack; quack { $hl_full, $hl_half, \%mods };

	return \%mods;
}

sub describe_modifiers
{
	my($self, $char, $stat, $current_mod) = @ARG;

	return unless $self->is_modifier_of($stat->id);

	my $stat_id = $stat->id;
	my $hl_full = $self->heroic_level;
	my $hl_half = int($hl_full / 2);

	my $how = '';

	if ($stat_id =~ /Skill/) {
		my $modified_stat = grep { $ARG->id eq $stat_id } ( @{ $self->skills } );
		$how = "HL$hl_full/+$hl_half" if $modified_stat;
	}
	elsif ($stat_id =~ /Defense/) {
		$how = "HL$hl_full/+$hl_full";

		my($modified_stat) = grep { $ARG->id eq $stat_id } ( @{ $self->defenses } );
		if ($modified_stat) {
			my %max_bonus = $self->max_class_defense_bonus($stat_id);
			$how .= ", " . $max_bonus{'nick'} . '/+' . $max_bonus{'mod'};
		}
	}

	return unless $how;
	return $how;
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



