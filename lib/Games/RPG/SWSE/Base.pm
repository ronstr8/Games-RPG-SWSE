package Games::RPG::SWSE::Base;

=head1 NAME

Games::RPG::SWSE::Base - Attributes common to all SWSE statistics

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;
use Time::Piece;
use UNIVERSAL::require;

use Moose;

=head1 ATTRIBUTES

Object attributes.

=cut

=head2 character ( Games::RPG::SWSE::Character )

The character to which this entity is attached.

=cut

has 'character' => (
	'is'         => 'rw',
	'isa'        => 'Games::RPG::SWSE::Character',
	'handles'    => [qw( verbosity )],
);

=head2 nick

Short all-word-character identifier for this entity.

=cut

has 'nick' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_nick { my $nick = shift->id; $nick =~ s/^[A-Z][a-z]+//; $nick; }

=head2 id

A unique identifier for the entity.  Usually composed of the base
class name plus the nick.

=cut

has 'id' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_id { my $id = ref(shift); my @id = split(/::/, $id); $id[-2] . $id[-1]; }

=head2 name

An short descriptive name/phrase for this entity.

=cut

has 'name' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_name { my $name = shift->nick; $name =~ s/(.)([A-Z])/$1 $2/g; $name; }

=head2 description

Some description of this entity.

=cut

has 'description' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_description { '' }

=head2 modifier

The modifier applied to any dice roll using this statistic.

=cut

has 'modifier' => (
	'is'          => 'rw',
	'isa'         => 'Maybe[Int]',
	'trigger'     => sub { shift->clear_modifier_of },
	'lazy_build'  => 1,
);

=head2 score ( $int )

Only applicable to L<Games::RPG::SWSE::Ability>, this defines that score.

=cut

has 'score' => (
	'is'          => 'rw',
	'isa'         => 'Int',
	'traits'      => [qw( Counter )],
	'handles'     => {
			'inc_score' => 'inc',
		},
	'lazy_build'  => 1,
);
sub _build_score { 0 }

=head2 level, rank ( $int )

Either the level (e.g. for a class) or the rank (e.g. for a feat or talent)
attained by the character.

=cut

=head2 max_level, max_rank ( $int )

The maximum level (unlikely) or rank (for feats/talents) that can be taken in
this statistic.

=cut

has '_level_or_rank' => (
	'is'          => 'rw',
	'isa'         => 'Maybe[Int]',
	'lazy_build'  => 1,
);
sub _build__level_or_rank { 0 }

has '_max_level_or_rank' => (
	'is'          => 'rw',
	'isa'         => 'Maybe[Int]',
	'lazy_build'  => 1,
);
sub _build__max_level_or_rank {}

sub max_rank  { shift->_max_level_or_rank(@ARG) }
sub rank
{
	my $self  = shift;
	return $self->_level_or_rank() unless @ARG;

	my $value = $ARG[0];
	my $max   = $self->max_rank;

	if (not defined($max)) {
		## Eh, we don't care.
	}
	elsif (not defined($value)) {
		## Eh, whatever.
	}
	elsif ($value <= $max) {
		## Yeah, you're cool.
	}
	else {
		die sprintf('level/rank for %s may not be greater than %s',
			$self->name, $max);
	}

	$self->_level_or_rank(@ARG);
	return $self->_level_or_rank();
}
sub max_level { shift->max_rank(@ARG) }
sub level     { shift->rank(@ARG)     }

=head2 scargs ( \%stat_options )

Certain statistics take some argument to determine their affect.  For example,
C<Knowledge> comes in several varieties, and the C<Skill Training> feat needs
to know what skill to train.

This hash-ref contains those arguments, interpreted in some way by the
statistic.

=cut

has 'scargs' => (
	'is'      => 'rw',
	'isa'     => 'HashRef',
	'traits'  => [qw( Hash )],
	'handles' => {
			'get_scarg' => 'get',
		},
	'default' => sub { +{} },
);

=head2 subclasses

A list of class names for all statistics of this type.  All have been used
(required/imported) and are ready to be instantiated.

=cut

=head2 subclass ( Some::SubClass->id )

Fetch a subclass by its id.

=cut

has '_subclasses_by_id' => (
	'is'         => 'rw',
	'isa'        => 'HashRef',
	'traits'     => [qw( Hash )],
	'handles'    => {
			'subclass'   => 'get',
			'subclasses' => 'values',
		},
	'lazy_build' => 1,
);
sub _build__subclasses_by_id
{
	my $self = shift;

	my $base_class = ref($self);

	my $relative_path =  $base_class;
	   $relative_path =~ s{::}{/}g;
	   $relative_path .= '.pm';

	my $container_path = $INC{$relative_path}
		or die "failed to determine path containing subclasses of $base_class (looked in \$INC{'$relative_path'})";
	   $container_path =~ s/\.pm$//;

	opendir(my $dh, $container_path)
		or die "failed to open subclass container path $container_path";

	my %subclasses = map { s/\.pm$//; $ARG => "${base_class}::$ARG" }
		grep { /\.pm$/ } ( readdir($dh) );

	foreach my $subclass (values %subclasses) {
		$subclass->use
			or die "failed to use subclass $subclass: $EVAL_ERROR";
	}

	closedir($dh);

	return \%subclasses;
}

=head2 all_subclass_kids

Instantiated instances of all L<subclasses>, ordered by L<display_order>.

=cut

has 'all_subclass_kids' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef',
	'lazy_build' => 1,
);
sub _build_all_subclass_kids
{
	my $self = shift;

	my($sort_attr, $sort_sub);

	if ($self->display_order eq 'alpha_by_id') {
		$sort_attr = 'id';
		$sort_sub  = sub { $a->[1] cmp $b->[1] };
	}
	else {
		$sort_attr = 'display_order';
		$sort_sub  = sub { $a->[1] <=> $b->[1] };
	}

	my $character = $self->character;
	my %kargs;
	   $kargs{'character'} = $character if $character;

	my @kids_and_sort_keys;

	foreach my $subclass (( $self->subclasses )) {
		my $kid = $subclass->new(%kargs);
		push @kids_and_sort_keys, [ $kid, $kid->$sort_attr ];
	}

	my @sorted_kids = map { $ARG->[0] } grep { $ARG->[1] } sort $sort_sub @kids_and_sort_keys;
	return \@sorted_kids;
}

=head2 display_order

Some indicator of how to sort this statistic when displayed.  For the base
class, this should be set to either C<alpha_by_id> or the default C<explicit>.
In the case of C<explicit>, override C<_build_display_order> in subclasses to
set their ascending order.  Use 0 to omit a child of a subclass from display.

=cut

has 'display_order' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_display_order { 'alpha_by_id' }

has 'size_class_name' => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);
sub _build_size_class_name
{
	my $self = shift;

	my %sizes = (
		0 => 'Fine',
		1 => 'Diminutive',
		2 => 'Tiny',
		3 => 'Small',
		4 => 'Medium',
		5 => 'Large',
		6 => 'Huge',
		7 => 'Gargantuan',
		8 => 'Colossal',
	);
	return $sizes{ $self->size_class } || 'Unknown';
}


=head2 modifier_of, modified_by

An array-ref of id of other entities indicating a relationship in which one may
affect the ultimate modifier of another.

Some such relations are hardcoded, such as the basic ability mods.  Others,
such as those by various feats, define the statistics they modify here.

=cut

has 'modifier_of' => (
	'is'         => 'rw',
	'isa'        => 'HashRef',
	'traits'     => [qw( Hash )],
	'handles'    => {
			'set_modified_stat' => 'set',
			'get_stat_modifier' => 'get',
			'is_modifier_of'    => 'exists',
			'modified_stats'    => 'keys',
		},
	'lazy_build' => 1,
);
sub _build_modifier_of { +{} }

has 'modified_by' => (
	'is'         => 'rw',
	'isa'        => 'ArrayRef',
	'traits'     => [qw( Array )],
##	'trigger'    => sub { shift->clear_modifier },
	'handles'    => {
			'add_modifying_stat'   => 'push',
			'modifying_stats'      => 'elements',
			'grep_modifying_stats' => 'grep',
		},
	'lazy_build' => 1,
);
sub _build_modified_by { +[] }

sub _update_all_modified_stats
{
	my($self) = @ARG;

	my $char             = $self->character;
	my @modified_stat_id = ( $self->modified_stats );
##	$self->clear_modifier_of;
	$char->statistic($ARG)->clear_modifier for @modified_stat_id;
}

=head2 add_modifying_stat ( Games::RPG::SWSW::Base )

Unconditionally add the given statistic as a modifier to this one, even if
something with its id already exists.

=cut

=head2 vivify_modifying_stat ( Games::RPG::SWSW::Base )

Add the given statistic as a modifier to this one, if one with its id doesn't
already exist.

=cut

sub vivify_modifying_stat
{
	my($self, $stat) = @ARG;

	my $modifying_stat_id = $stat->id;

	my(@gotcha) = $self->grep_modifying_stats(
		sub { $ARG->id eq $modifying_stat_id } );
	$self->add_modifying_stat($stat) unless @gotcha;

#	$self->clear_modified_by;
#	$self->clear_modifier;

	return $stat;
}

=head2 apply_modifiers ( Games::RPG::SWSE::Character, Games::RPG::SWSE::Base, $current_mod )

Return an adjustment to the given L<$current_mod> bestowed by virtue of
possessing this statistic.

=cut

sub apply_modifiers
{
	my($self, $char, $stat, $current_mod) = @ARG;

	my $modification = $self->get_stat_modifier($stat->id);
	my $mod;

	if (not $modification) {
		$self->_debug(sprintf('No modification to %s??? [mod=%d+%s=%d]', $stat->id, $current_mod, $mod // '<undef>', $current_mod+($mod//0) ),
			); # sub { $stat->id =~ /Defense/ });
		return;  ## WTF?
	}
	elsif (!ref($modification)) {
		$mod = $modification;
		$self->_debug(sprintf('Raw modification to %s [mod=%d+%s=%d]', $stat->id, $current_mod, $mod // '<undef>', $current_mod+($mod//0) ),
			); # sub { $stat->id =~ /Defense/ });
	}
	elsif (ref($modification) eq 'CODE') {
		$mod = $modification->(@ARG);
		$self->_debug(sprintf('Subref modification to %s [mod=%d+%s=%d]', $stat->id, $current_mod, $mod // '<undef>', $current_mod+($mod//0) ),
			); # sub { $stat->id =~ /Defense/ });
	}
	else {
		die 'stat modification is neither a scalar nor a code reference';
	}

	return $mod // 0;
}

=head2 describe_modifiers ( Games::RPG::SWSE::Character, Games::RPG::SWSE::Base, $current_mod )

Return a description of the modifier explained above.

=cut

sub describe_modifiers
{
	my($self, $char, $stat, $current_mod) = @ARG;

	return unless $self->is_modifier_of($stat->id);

	my $modder = $self->get_stat_modifier($stat->id);
	my $mod    = ref($modder) ? '' : $modder;
	   $mod //= 0;

	return $self->nick if $mod eq '';
	return '' unless $mod;
	return $self->nick . '/' . ( ( $mod < 0 ) ? '-' : '+' ) . abs($mod);
}


=head2 modifier ( Games::RPG::SWSE::Character )

The normal modifier for this statistic.  Default behaviour queries all
L<modified_by> statistics.

=cut

sub _build_modifier
{
	my $self = shift;
	my $char = $self->character;

	my $mod = 0;
	my %applied_stats;

	foreach my $stat (( $self->modifying_stats ), $char) {
		next unless $stat;
		next if $applied_stats{"$stat"};

		my $modification = 
			$stat->apply_modifiers($char, $self, $mod);
		$mod += $modification if defined $modification;
		$applied_stats{"$stat"}++;
	}

	return $mod;
}

no Moose; __PACKAGE__->meta->make_immutable;

sub _debug
{
	my($self, $msg, $conditional) = @ARG;

	if (not defined $conditional) {
		return unless $self->verbosity > 0;
	}
	elsif (ref($conditional) and (ref($conditional) eq 'CODE')) {
		return unless $conditional->();
	}
	else {
		return $self->verbosity >= $conditional;
	}

	warn sprintf("[%s] %s => %s\n", localtime->datetime, $self->id, $msg);
}


=head1 METHODS

Methods called on an instantiated object.

=cut

=head2 roll_dice ( @xdx )

Simple utility to simulate rolling dice.  Accepts standard dice-d-sides with an
option +/-/* afterward.

=cut

sub roll_dice
{
	my($self, @dspecs) = @ARG;

	my $roll  = 0;
	   $roll += $self->_roll_dice($ARG) for @dspecs;

	return $roll;
}

sub describe_dice
{
	my($self, @dspecs) = @ARG;

	my $total_step_inc = 0;
	my $total_dice_inc = 0;
	my $total_open_mod = 0;

	my @d;

	foreach my $dspec (@dspecs) {
		next unless $dspec;
		my %dparsed = $self->_parse_dspec($dspec);
		my($faces, $dice, $modop, $modval, $stepinc, $diceinc)
			= @dparsed{qw( faces dice modop modval stepinc diceinc )};

		$total_step_inc += $stepinc || 0;
		$total_dice_inc += $diceinc || 0;
		$total_open_mod += $modval  || 0 if not $faces;

		push @d, [ $faces, $dice, $modop, $modval ];
	}

	if ($total_step_inc) {
		my %steps = (
			'4'  =>  '6',
			'6'  =>  '8',
			'8'  => '10',
			'10' => '12',
			'12' => '20',
		);
##		my @steps = qw( 0 1 2 3 4 6 6 8 8 10 10 12 12 20 );

		foreach my $d_ar (@d) {
			next unless my $faces = $d_ar->[0];

			foreach my $step_inc ( 1 .. $total_step_inc ) {
##				$faces = $steps[$faces + $step_inc];
				$faces = $steps{$faces};
			}

			$d_ar->[0] = $faces;
		}
	}

	my %d;

	foreach my $dinfo_ar (@d) {
		my($faces, $dice, $modop, $modval) = @{ $dinfo_ar };
		$d{$faces}{'dice'} += $dice // 0;

		if ($modop eq '/') {
			( $d{$faces}{'mod_divisor'} ||= 1 ) *= ( $modval || 0 );
		}
		elsif (($modop eq 'x') or ($modop eq '*')) {
			( $d{$faces}{'mod_product'} ||= 1 ) *= ( $modval || 0 );
		}
		else {
			( $d{$faces}{'mod_sum'}     ||= 0 ) += ( $modval || 0 );
		}
	}

	my @ddesc;

	while (my($faces, $dinfo_hr) = each(%d)) {
		next unless $faces;
		$dinfo_hr->{'dice'} += $total_dice_inc;

		my $mod_expr  = '';

		my $mod_sum      = ( $dinfo_hr->{'mod_sum'}     ||= 0 ) + ( $d{0}{'mod_sum'}     || 0 );
		   $mod_expr    .= ( ' ' . (( $mod_sum < 0 ) ? '-' : '+' ) . abs($mod_sum)) if $mod_sum;

		my $mod_divisor  = ( $dinfo_hr->{'mod_divisor'} ||= 1 ) * ( $d{0}{'mod_divisor'} || 1 );
		   $mod_expr    .= ( ' / ' . $mod_divisor ) if $mod_divisor > 1;

		my $mod_product  = ( $dinfo_hr->{'mod_product'} ||= 1 ) * ( $d{0}{'mod_product'} || 1 );
		   $mod_expr    .= ( ' x ' . $mod_product ) if $mod_product > 1;

		push @ddesc, sprintf('%dd%d%s ',
			( $dinfo_hr->{'dice'} ||  0 ),
			( $faces              ||  0 ),
			  $mod_expr,
		);
	}

	return join(' + ', @ddesc);
}

sub _parse_dspec
{
	my($self, $dspec) = @ARG;

	my %r;

	if ($dspec =~ qr{^(?<incexpr>[+-]\d+)d$}) {
		$r{'faces'}   = 0;
		$r{'diceinc'} = $+{'incval'} || 1;
	}
	elsif ($dspec =~ qr{^(?<incexpr>d\+\+|d+=(?<incval>\d+))$}) {
		$r{'faces'}   = 0;
		$r{'stepinc'} = $+{'incval'} || 1;
	}
	elsif ($dspec =~ /^[+-](?<modval>\d+)$/) {
		$r{'faces'}   = 0;
		$r{'modval'} = $+{'modval'};
	}
	elsif ($dspec
		=~ qr{^(?<dspec>(?<dice>\d+)?[dD](?<faces>\d+))?(\s*(?<modop>[-+*x/])(?<modval>\d+)\s*)?$}) {

		$r{'dice'}   = $+{'dice'};
		$r{'faces'}  = $+{'faces'};
		$r{'modop'}  = $+{'modop'};
		$r{'modval'} = $+{'modval'};
	}
	else {
		die "invalid dice spec $dspec";
	}

	$r{'dice'}   //=  1;
	$r{'faces'}  //=  0;
	$r{'modop'}  //= '+';
	$r{'modval'} //=  0;

	return %r;
}

sub _roll_dice
{
	my($self, $dspec) = @ARG;

	my %dparsed = $self->_parse_dspec($dspec);
	my($dice, $faces, $modop, $modval) = @dparsed{qw( dict faces modop modval )};

	my $roll = 0;

	if ($dspec) {
		$roll += int(rand($faces)+1) for ( 1 .. $dice );
	}

	if (not $modop) {
		## Whatever we rolled.
	}
	elsif ($modop eq '+') {
		$roll += $modval;
	}
	elsif ($modop eq '-') {
		$roll -= $modval;
	}
	elsif ($modop eq '/') {
		$roll /= $modval;
	}
	elsif ($modop eq 'x' or $modop eq '*') {
		$roll *= $modval;
	}

	return 1 if $roll < 1;
	return int($roll);
}


=head2 as_text_blurb ( Games::RPG::SWSE::Character )

A short text blurb describing the game statistic as applied to the given
character.

=cut

sub as_text_blurb
{
	my($self, $char) = @ARG;

	my $output = '';

	my $name_blurb     = $self->name_as_text_blurb($char);

	## Do the mod blurb before the other modifier-based data, so any modifiers
	## can do their magic, e.g. so the 'F' flag shows for a FeatSkillFocus.
	my $mod_blurb      = $self->base_modifier_as_text_blurb($char);
	my $score_blurb    = $self->score_as_text_blurb($char);
	my $modifier_blurb = $self->modifying_stats_as_text_blurb($char);

	$output .=       $name_blurb;
	$output .= ' ' . $score_blurb;
	$output .= ' ' . $mod_blurb;
	$output .= ' ' . $modifier_blurb;

	return $output;
}

=head2 name_as_text_blurb

The name of the skill suitable for displaying in a text sheet.

=cut

sub name_as_text_blurb
{
	my $self = shift;
	my $char = shift;
	my $name = shift // $self->name;

	return sprintf('%-20.20s', $name);
}

=head2 modifying_stats_as_text_blurb

A list of modifying stats and maybe what they do or some shit.

=cut

sub modifying_stats_as_text_blurb
{
	my($self, $char) = @ARG;

	my $idx = 0;
	my %modifying_stats = map { +"$ARG" => [ $ARG, $idx++ ] } (
		$char, ( $self->modifying_stats ), $char );
	my @modifying_stats = map { $ARG->[0] } sort { $a->[0] <=> $b->[0] }
		values %modifying_stats;

	return join(', ', grep { $ARG } ( map { $ARG->describe_modifiers($char, $self, 0) }
		@modifying_stats));
##		( $self->modifying_stats ), $char));
}

=head2 score_as_text_blurb

A three-character description of any score or other indicator of profiency
associated with this game statistic.

=cut

sub score_as_text_blurb
{
	my($self, $char) = @ARG;

	my $score = $self->score;
	return sprintf('%3.3s', $score // '');
}

=head2 base_modifier_as_text_blurb

A seven-character wide description of any modifier associated with this
game statistic.

=cut

sub base_modifier_as_text_blurb
{
	my($self, $char) = @ARG;

	return ' ' x 7 unless defined(my $mod = $self->modifier);

	my $sign = $mod ? ( ($mod > 0) ? '+' : '-' ) : ' ';
	return sprintf('[ %s%2.2s ]', $sign, abs($mod));
}

sub _map_list_by_id
{
	my($self, $stats_ar) = @ARG;

	my %map = map {
		$ARG->id => $ARG
	} @{ $stats_ar };

	return \%map;
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



