package Games::RPG::SWSE::Sheet::Character::CombatStats::AttackTypeRole::Ranged;

use strict;
use warnings;
use English qw( -no_match_vars );

use List::Util;

use Moose::Role;

no Moose; __PACKAGE__->meta->make_immutable;

sub make_attack_type_stats_table
{
	my $self = shift;
	my $char = $self->char;

	my $name = $weapon->name;
	my $bab  = $weapon->base_attack_bonus;

	my $half_level_bonus  = int($char->heroic_level / 2);
	   $half_level_bonus  = "+$half_level_bonus";

	my @base_kill_dmg_dice = ( @{ $weapon->base_kill_damage_dice || [] }, $half_level_bonus );
	my @base_stun_dmg_dice = ( @{ $weapon->base_stun_damage_dice || [] }, $half_level_bonus );

	my $base_kill_dmg_dice_desc = $self->describe_dice(@ranged_kill_dmg_dice);
	my $base_stun_dmg_dice_desc = $self->describe_dice(@ranged_stun_dmg_dice);

	my $dmg_type = join('/', @{ $weapon->damage_type });

	my $colgroup = '';
	my $tbody    = '';
	my $thead    = <<"EOT";
		<tr>
			<th class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellAttackTypeName" rowspan="2">$name</th>
			<th class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellBAB" colspan="2">BAB: <code class="writeover">$bab</code></th>
			<th class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellKillDmg" colspan="2">Kill: <code class="writeover">$base_kill_dmg_dice_desc</code></th>
			<th class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellStunDmg" colspan="2">Stun: <code class="writeover">$base_stun_dmg_dice_desc</code></th>
			<th class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellDmgclass" colspan="2"><code class="writeover">$dmg_type</code></th>
		</tr>
EOT

	my @range_increments = @{ $weapon->range_increments };

	my @th_rows;
	my @tl_rows_atk;
	my @tl_rows_dmg;

	foreach my $attack_mode (qw( Normal )) {
		foreach my $range_inc_ar (@range_increments) {
			my($nick, $name, $min, $max, $penalty) = @{ $range_inc_ar };
			my $bab_modded             = $bab + $penalty + $feat_atk_mods;
			my $kill_dmg_dice_desc = $self->describe_dice(@base_kill_dmg_dice, $feat_dmg_mods);

			my @th_row = (
				qq{<th class="SwseSheetCombatStatsSkill SwseSheetCombatStatsCellAttackMode">$attack_mode</th>},
				qq{<th class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellAttackVariant" colspan="3">$name ($min - $max sq)</th>},
			);

			my @tl_row_atk = (
				qq{<td class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellAtk"><code class="writeover">$bab_modded</code></td>},
			);

			my @tl_row_dmg = (
				qq{<td class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellDmg"><code class="writeover">$kill_dmg_dice_desc</code></td>},
			);

			push @th_rows,     join('', @th_row);
			push @th_rows_atk, join('', @th_row_atk);
			push @th_rows_dmg, join('', @th_row_dmg);
		}
	}

	foreach my $row_ii ( 0 .. $#th_rows ) {
		$tbody .= '<tr>' . $th_rows[$row_ii]     . '</tr>';
		$tbody .= '<tr>' . $th_rows_atk[$row_ii] . '</tr>';
		$tbody .= '<tr>' . $th_rows_dmg[$row_ii] . '</tr>';
	}

	my $breaker_class = 'SwseSheetSessionLogModLogPageBreak';
	return qq{<table class="SwseSheetCombatStatsAttackType $breaker_class">$colgroup<thead>$thead</thead><tbody>$tbody</tbody></table>};
}

1;

