package Games::RPG::SWSE::Sheet::Character::CombatStats;

use strict;
use warnings;
use English qw( -no_match_vars );

use List::Util;

use Moose;
extends qw( Games::RPG::SWSE::Sheet::CharacterHTML );

has 'modlog_lines' => (
	'is'      => 'rw',
	'isa'     => 'Int',
	'default' => 48,
);

override '_build_style' => sub
{
	my $self = shift;

	my $markup  = ''; ## super();
	   $markup .= <<EOT;

		<style type="text/css">
			body
			{
				font-family: Sans;
				font-size:   10px ! important;
				margin:      1ex;
			}

			table.SwseSheetCombatStatsAttackType
			{
				border-collapse: collapse;
				margin-top:      1ex;
				padding:         1ex;
/*				max-width:       10in; */
				margin-right:    1in;
			}
			table.SwseSheetCombatStatsAttackType tr
			{
				max-height: 1ex;
			}
			table.SwseSheetCombatStatsAttackType th
			{
				background-color: wheat;
			}
			table.SwseSheetCombatStatsAttackType th.SwseSheetCombatStatsAttackMode
			{
				text-align:       center;
				vertical-align:   middle;
			}
			table.SwseSheetCombatStatsAttackType td,
			table.SwseSheetCombatStatsAttackType th
			{
				border:        1px solid #000000;
				padding-left:  2px;
				padding-right: 2px;
				min-width:     8ex;
			}

			table.SwseSheetCombatStatsAttackType .SwseSheetCombatStatsCellAttackTypeName
			{
				font-style: italic;
				font-size:  smaller;
				color:      saddlebrown;
			}
			table.SwseSheetCombatStatsAttackType .SwseSheetCombatStatsCellAttackType
			{
				border-top: none;
				font-size:  smaller;
			}

			table.SwseSheetCombatStatsAttackType th.SwseSheetCombatStatsCellBAB,
			table.SwseSheetCombatStatsAttackType th.SwseSheetCombatStatsCellKillDmg,
			table.SwseSheetCombatStatsAttackType th.SwseSheetCombatStatsCellStunDmg,
			table.SwseSheetCombatStatsAttackType th.SwseSheetCombatStatsCellDmgType
			{
				text-align: left;
			}
			table.SwseSheetCombatStatsAttackType .SwseSheetCombatStatsCellBlank
			{
				border-bottom: none;
			}
			table.SwseSheetCombatStatsAttackType .SwseSheetCombatStatsCell
			{
				vertical-align:   middle;
				padding:          0.5ex 1ex 0.5ex 1ex;
			}
			.SwseSheetCombatStatsAttackTypes code
			{
				font-size: smaller ! important;
			}
			code.writeover
			{
				color:       #aaaaaa;
				font-family: Consolas, monospace;
				font-weight: lighter;
				font-size:   12px ! important;
				float:       right;
			}
			code.scribbled
			{
				color:       saddlebrown;
				font-size:   12px ! important;
				float:       right;
			}
			table.SwseSheetCombatStatsAttackType .SwseSheetCombatStatsCellAtk
			{
				border-right:   1px dashed #000000;
			}
			table.SwseSheetCombatStatsAttackType .SwseSheetCombatStatsCellDmg
			{
				border-left:    1px dashed #000000;
			}
			table.SwseSheetCombatStatsAttackType .SwseSheetCombatStatsCellCombatNotes
			{
				text-align:     left;
				border-right:   none;
			}
			table.SwseSheetCombatStatsAttackType .SwseSheetCombatStatsCellDmgClass
			{
				border-left:    none;
			}
			table.SwseSheetCombatStatsAttackType .SwseSheetCombatStatsCellAttackVariant
			{
				background-color: wheat;
				font-size:        smaller ! important;
			}

			td.SwseSheetCombatStatsH2H
			{
				vertical-align: top;
			}

			table.SwseSheetCombatStatsCoreScoresheet
			{
				border:          1px solid;
				border-collapse: collapse;
			}
			table.SwseSheetCombatStatsCoreScoresheet th,
			table.SwseSheetCombatStatsCoreScoresheet td
			{
				padding:    0.5ex;
			}
			table.SwseSheetCombatStatsCoreScoresheet th
			{
				background-color: wheat;
				color:            saddlebrown;
				min-width:        25ex;
				text-align:       left;
			}
			table.SwseSheetCombatStatsCoreScoresheet td
			{
				min-width: 4ex;
			}
			td.SwseSheetCombatStatsCoreScoresheetBase,
			td.SwseSheetCombatStatsCoreScoresheetChange
			{
				padding-left: 1em;
			}

			table.SwseSheetCombatStatsTitleDate td.SwseSheetCombatStatsTitleDateLabel
			{
				font-weight:    bold;
				vertical-align: bottom;
			}
			table.SwseSheetCombatStatsTitleDate td.SwseSheetCombatStatsTitleDateValue
			{
				border-bottom: 1px solid #000000;
				min-width:     8ex;
				width:         8ex;
			}
			table.SwseSheetCombatStatsTitleDate td
			{
				max-height: 1ex;
				height:     1ex;
			}
			table.SwseSheetCombatStatsTitleDate
			{
				margin-left: 2ex;
			}


			.SwseSheetCombatStatsAttackTypePageBreak
			{
				page-break-before: always;
			}

			.SwseSheetCombatStatsAttackTypes h2
			{
				margin:    1ex;
				padding:   1ex;
			}
			.SwseSheetCombatStatsTitle
			{
				border-bottom: 1px solid saddlebrown;
				font-size:     larger;
				font-weight:   bold;
			}
		</style>

EOT

	return $markup;
};

override '_build_header_title' => sub
{
	my $self  = shift;
	my $title = $self->title;

	return qq{<div class="SwseSheetCombatStatsTitle">$title</div>\n};
};


override '_build_title' => sub
{
	my $self = shift;
	return 'Star Wars Saga Edition Combat Stats - ' .  $self->character->name;
};


override '_build_content' => sub
{
	my $self   = shift;
	my $markup = ''; ## super();

	my $class_namespace = 'Games::RPG::SWSE';
	my @class_basenames = qw( WeaponUnarmed WeaponMelee WeaponRanged WeaponThrown );
	my %buckets         = map { $ARG => [] } @class_basenames;

	foreach my $equipment (@{ $self->character->_equipment }) {
		next unless eval { $equipment->isa("${class_namespace}::Weapon") };

		my $weapon_class = List::Util::first
			{ $equipment->isa("${class_namespace}::$ARG") } keys %buckets;
		push @{ $buckets{$weapon_class} }, $equipment;
	}

	$markup .= q{<div class="SwseSheetCombatStatsAttackTypes">};
##	$markup .= $self->__running_stats_block;

	my $class;
	$markup .= q{<table border="0"><tr>};

	$class   = 'WeaponMelee';
	$markup .= q{<td class="SwseSheetCombatStatsH2H">};
	$markup .= $self->_make_modlog_table($ARG, $class) for @{ $buckets{$class} };
	$markup .= q{</td>};

	$class   = 'WeaponUnarmed';
	$markup .= q{<td class="SwseSheetCombatStatsH2H">};
	$markup .= $self->_make_modlog_table($ARG, $class) for @{ $buckets{$class} };
	$markup .= q{</td>};

	$markup .= q{</tr></table>};

	foreach my $class (qw( WeaponRanged WeaponThrown )) {
		$markup .= $self->_make_modlog_table($ARG, $class) for @{ $buckets{$class} };
	}
	$markup .= '</div>';

	return $markup;
};

override '_build_header_details' => sub { '' };

sub __running_stats_block
{
	my $self = shift;

##	return ''; ## XXX :: This is in the master session log.  Don't need here.

	my $char = $self->character;
	my $bab  = $char->base_attack_bonus;

	my @tracked = (
		['Fortitude'    => sub { $char->statistic('DefenseFORT')->modifier } ],
		['Reflex'       => sub { $char->statistic('DefenseREF')->modifier } ],
		['Dodging'      => sub { $char->statistic('DefenseREF')->modifier + 1} ],
		['Willpower'    => sub { $char->statistic('DefenseWILL')->modifier } ],
		['Initiative'   => sub { $char->statistic('SkillInitiative')->modifier } ],
##		['&nbsp;' => sub { '&nbsp;' } ],
##		['Base Attack Bonus'  => sub { $char->statistic('BABBase')->modifier } ],
##		['Melee/Thrown'       => sub { $char->statistic('BABMelee')->modifier } ],
##		['Ranged'             => sub { $char->statistic('BABRanged')->modifier } ],
##		['&nbsp;' => sub { '&nbsp;' } ],
		['Temp Atk Bonus' => sub { '&nbsp;' } ],
		['Temp Dmg Bonus' => sub { '&nbsp;' } ],
		['Temp Skill Bonus'  => sub { '&nbsp;' } ],
##		['&nbsp;' => sub { '&nbsp;' } ],
		['HP'           => sub { $char->hit_points } ],
	);

	my $extra_cols = 13;
	my $base_cell_class = 'SwseSheetCombatStatsCoreScoresheet';

	my @rows = map {
		my($title, $valsub) = @{ $ARG };
		"<th>$title</th>"
			. ( qq'<td class="${base_cell_class}Base"><code class="scribbled">' . $valsub->($title) . '</code></td>' )
			. ( qq'<td class="${base_cell_class}Change">&nbsp;</td>' x $extra_cols );
	} @tracked;

	my $rows = '<tr>' . join("\n</tr>\n<tr>\n", @rows) . '</tr>';

	my $markup  = ''; ## super();
	   $markup .= <<"EOT";

	<table class="SwseSheetCombatStatsCoreScoresheet" border="1">
		<tbody>
			$rows
		</tbody>
	</table>

EOT

	return $markup;
};

no Moose; __PACKAGE__->meta->make_immutable;

sub _make_modlog_table
{
	my $self   = shift;
	my $weapon = shift;
	my $class  = shift || '';
	   $class =~ s/^Weapon//;
	   $class  = "${class} - " if $class;
	my %stats  = $weapon->combat_stats;

	my $attack_mode_name  = $stats{'name'};
	my $attack_mode_notes = $stats{'notes'};
	my $base_damage_desc  = $stats{'base_damage_desc'};
	my @modes             = @{ $stats{'modes'}    };
	my @variants          = @{ $stats{'variants'} };

	my $notes_span = ( +@modes - 1 ) * 2;
	$notes_span++; ## XXX

	my $thead = <<"EOT";
			<tr>
				<th class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellCombatNotes" colspan="$notes_span">
					<span class="SwseSheetCombatStatsCellAttackTypeName">$class$attack_mode_name</span>
					<code class="scribbled">$attack_mode_notes</code>
				</th>
				<th class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellDmgClass" colspan="2">
					<code class="scribbled">$base_damage_desc</code>
				</th>
			</tr>
EOT

	$thead .= qq{<tr><th class="SwseSheetCombatStatsCellBlank"></th>\n};
	$thead .= qq{<th class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellAttackVariant" colspan="2">$ARG</th>\n} for @modes;
	$thead .= "</tr>\n";

	my $tbody = '';

	foreach my $variant_ar (@variants) {
		my($vname, $vcols_ar) = @{ $variant_ar };
		my $tline  = qq{<th class="SwseSheetCombatStatsSkill SwseSheetCombatStatsCellAttackType">$vname</th>};

		my @vcols = @{ $vcols_ar };

		foreach my $vcol_ar (@vcols) {
			my($attack_bonus, $damage) = @{ $vcol_ar };

			$tline .= qq{
				<td class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellAtk">
					<code class="writeover">$attack_bonus</code>
				</td>
				<td class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellDmg">
					<code class="writeover">$damage</code>
				</td>
			};
		}

		$tbody .= "<tr>$tline</tr>";
	}
	

	my $breaker_class = 'SwseSheetSessionLogModLogPageBreak';

	my $markup = <<"EOT";
		<table class="SwseSheetCombatStatsAttackType $breaker_class">
			<thead>
				$thead
			</thead>
			<tbody>
				$tbody
			</tbody>
		</table>
EOT

	return $markup;
}

1;

