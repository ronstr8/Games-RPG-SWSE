package Games::RPG::SWSE::Sheet::Character::SessionLog;

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

has 'modlog_headers' => (
	'is'             => 'rw',
	'isa'            => 'ArrayRef',
	'lazy_build'     => 1,
);

sub _build_modlog_headers
{
	my $self = shift;

	my(@headers) = qw(
		XP/Xp
		HP/Hp
		FP/Fp
		DP/Dp
		Atk+/BAB
		Dmg+/Damage
		Fort/Defense
		Ref/Defense
		Will/Defense
		Skill+/Skill
		Credits/Credits
		Other/Misc*2
	);

	return \@headers;
}

override '_build_style' => sub
{
	my $self = shift;

	my $markup  = super();
	   $markup .= <<EOT;

		<style type="text/css">
			table.SwseSheetSessionLogModLog
			{
				border-collapse: collapse;
				margin-top:      1ex;
			}
			table.SwseSheetSessionLogModLog tr
			{
				max-height: 1ex;
			}
			table.SwseSheetSessionLogModLog th
			{
				background-color: #dddddd;
				font-size:        0.65em;
			}
			table.SwseSheetSessionLogModLog td,
			table.SwseSheetSessionLogModLog th
			{
				border:        1px solid #000000;
				padding-left:  2px;
				padding-right: 2px;
			}
			.SwseSheetSessionLogCell
			{
				vertical-align: top;
			}
			.SwseSheetSessionLogCellDay
			{
				width: 5ex;
			}
			.SwseSheetSessionLogCellDesc
			{
				width: 80ex;
			}
			.SwseSheetSessionLogCellTallyType
			{
				width:          3ex;
				font-family:    monospace;
				font-size:      0.70em;
				font-weight:    bold;
				vertical-align: middle;
				text-align:     center;
			}
			.SwseSheetSessionLogCellChangeType
			{
				width: 4ex;
			}
			.SwseSheetSessionLogCellXpChange
			{
				width: 8ex;
			}
			.SwseSheetSessionLogRowPrevious td
			{
				background-color: lightyellow;
			}
			.SwseSheetHeaderDetails th
			{
				background-color: #dddddd;
				padding:          1ex;
				vertical-align:   top;
				text-align:       left;
				font-size:        0.70em;
			}
			.SwseSheetHeaderDetails td
			{
				padding:          1ex;
				vertical-align:   top;
			}
			.SwseSheetHeaderDetailsSessionLogSummary td
			{
				min-height: 13ex;
				height:     13ex;
			}
			.SwseSheetHeaderDetails table
			{
				border-collapse: collapse;
				width:           100%;
			}
			.SwseSheetHeaderDetails table,
			.SwseSheetHeaderDetails td,
			.SwseSheetHeaderDetails th
			{
				border:          1px solid #000000;
			}
			table.SwseSheetSessionLogTitleDate td.SwseSheetSessionLogTitleDateLabel
			{
				font-size:      smaller;
				font-weight:    bold;
				vertical-align: bottom;
			}
			table.SwseSheetSessionLogTitleDate td.SwseSheetSessionLogTitleDateValue
			{
				border-bottom: 1px solid #000000;
				min-width:     11ex;
				width:         11ex;
			}
			table.SwseSheetSessionLogTitleDate td
			{
				max-height: 1ex;
				height:     1ex;
			}
			table.SwseSheetSessionLogTitleDate
			{
				margin-left: 2ex;
			}
			.SwseSheetSessionLogModLogPageBreak
			{
				page-break-before: always;
			}
			table.swsesheetsessionlogmodlog th.SwseSheetSessionLogCellCreditChange
			{
				background-color: #f5f5f5;
				background-image: url('../images/galactic-credit-symbol.png');
				color:            #000000;
				padding-bottom:   4ex;
				width:            10ex;
				vertical-align:   middle;
			}
			table.swsesheetsessionlogmodlog th.SwseSheetSessionLogCellMiscChange
			{
				background-color: #f5f5f5;
				color:            #dddddd;
				font-style:       italic;
				padding-bottom:   4ex;
				width:            10ex;
				vertical-align:   middle;
			}
		</style>

EOT

	return $markup;
};

override '_build_header_title' => sub
{
	my $self  = shift;
	my $title = $self->title;
	my $name  = $self->character->name;

	my $markup  = ''; ## super();
	   $markup .= <<"EOT";
	<table class="SwseSheetSessionLogTitleDate">
		<tbody>
			<tr>
				<td colspan="2">Star Wars Saga Edition Session Log - <% $name %></td>
			</tr>
			<tr>
				<td class="SwseSheetSessionLogTitleDateLabel">Date</td>
				<td class="SwseSheetSessionLogTitleDateValue">&nbsp;</td>
			</tr>
		</tbody>
	</table>

EOT
};


override '_build_title' => sub
{
	'SWSE Session Log';
};


override '_build_content' => sub
{
	my $self = shift;

	my $markup  = ''; ## super();
	   $markup .= $self->_make_modlog_table;

	return $markup;
};

override '_build_header_details' => sub 
{
	my $self = shift;

	my $markup  = ''; ## super();
	   $markup .= <<EOT;

	<table>
		<colgroup>
			<col width="10%" />
			<col width="90%" />
		</colgroup>
		<tbody>
			<tr class="SwseSheetHeaderDetailsSessionLogSummary">
				<th>Session Summary</th>
				<td>&nbsp;</td>
			</tr>
		</tbody>
	</table>

EOT

	return $markup;
};

no Moose; __PACKAGE__->meta->make_immutable;

sub _make_modlog_table
{
	my $self  = shift;
	my $lines = shift // $self->modlog_lines;

	my(@headers) = map {
		my($title, $idpart, $has_count, $count)
			= m{^(\w+)/(\w+)(\*(\d+))?$};
		$count ||= 1;

		map { [ $idpart, $title ] } ( 1 .. $count );
	} (( @{ $self->modlog_headers } ));


	my $colgroup = <<EOT;
EOT

	my $thead = <<EOT;
		<tr>
			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellDay">Day</th>
			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellDesc" colspan="2">Description</th>
EOT

	my $core_modlog_classes = 'SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType';

	foreach my $mod_ar (@headers) {
		$thead .= sprintf(qq{<th class="%s SwseSheetSessionLogCell%sChange">%s</th>\n},
			$core_modlog_classes, (( @{ $mod_ar } )) );
	}

## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellXpChange">XP</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellHpChange">HP</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellFpChange">FP</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDpChange">DP</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellBABChange">Atk</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDamageChange">Dmg</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDefenseChange">Fort</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDefenseChange">Ref</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDefenseChange">Will</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellSkillChange">Skill</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellCreditChange">Other</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellMiscChange">Other</th>
## 			<th class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellMiscChange">Other</th>

	$thead .= <<EOT;
		</tr>
EOT

	my $day_rowspan = ( $lines * 2 ) + 1;
	my $tstart_row = <<"EOT";
		<tr class="SwseSheetSessionLogRowPrevious">
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellDay" rowspan="$day_rowspan">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellDesc">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellTallyType">&#x22EF;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellPrevious SwseSheetSessionLogCellXpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellPrevious SwseSheetSessionLogCellHpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellPrevious SwseSheetSessionLogCellFpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellPrevious SwseSheetSessionLogCellDpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellPrevious SwseSheetSessionLogCellBABChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellPrevious SwseSheetSessionLogCellDamageChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellPrevious SwseSheetSessionLogCellDefenseChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellPrevious SwseSheetSessionLogCellDefenseChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellPrevious SwseSheetSessionLogCellDefenseChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellPrevious SwseSheetSessionLogCellSkillChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellCreditChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellMiscChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellMiscChange">&nbsp;</td>
		</tr>
EOT

	my $tchange_row = <<'EOT';
		<tr class="SwseSheetSessionLogRowChange">
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellDesc" rowspan="2">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellTallyType">+/-</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellXpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellHpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellFpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellBABChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDamageChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDefenseChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDefenseChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDefenseChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellSkillChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellCreditChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellMiscChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellMiscChange">&nbsp;</td>
		</tr>
		<tr class="SwseSheetSessionLogRowCurrent">
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellTallyType">===</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellXpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellHpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellFpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDpChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellBABChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDamageChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDefenseChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDefenseChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellDefenseChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellSkillChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellCreditChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellMiscChange">&nbsp;</td>
			<td class="SwseSheetSessionLogCell SwseSheetSessionLogCellChangeType SwseSheetSessionLogCellMiscChange">&nbsp;</td>
		</tr>
EOT

	my $markup        = '';
	my $lines_left    = $lines;
	my $base_break_at = 14;

	my(@bc_ba) = ( ['SwseSheetSessionLogModLogPageBreak', $base_break_at+3], [ '', $base_break_at ] );

	while ($lines_left > 0) {
		my($breaker_class, $break_at) = @{ $bc_ba[ ($lines_left == $lines) ? 1 : 0 ] };
		my $page_lines    = List::Util::min($lines_left, $break_at);
		   $lines_left   -= $page_lines;

		my @tbody = ( $tstart_row, ( map { $tchange_row } ( 1 .. $page_lines ) ) );
		my $tbody = join('', @tbody);

		$markup .= qq{<table class="SwseSheetSessionLogModLog $breaker_class">$colgroup<thead>$thead</thead><tbody>$tbody</tbody></table>};
	}

	return $markup;
}

1;

