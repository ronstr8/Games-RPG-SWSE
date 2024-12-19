package Games::RPG::SWSE::Sheet::Character::CombatStats::AttackTypeRole::Unarmed;

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

	my $single_str_bonus  = int($self->character->statistic('AbilitySTR')->modifier);
	   $single_str_bonus  = ( $single_str_bonus < 1 ) ? "-$single_str_bonus" : "+$single_str_bonus";

	my $double_str_bonus  = ( $single_str_bonus > 0 ) ? $single_str_bonus * 2 : $single_str_bonus;
	   $double_str_bonus  = ( $double_str_bonus < 1 ) ? "-$double_str_bonus"  : "+$double_str_bonus";

	my @base_kill_dmg_dice = ( @{ $weapon->base_kill_damage_dice || [] }, $half_level_bonus, $single_str_bonus );
	my @base_stun_dmg_dice = ( @{ $weapon->base_stun_damage_dice || [] }, $half_level_bonus, $single_str_bonus );

	my $base_kill_dmg_dice_desc = $self->describe_dice(@base_kill_dmg_dice);
	my $base_stun_dmg_dice_desc = $self->describe_dice(@base_stun_dmg_dice);

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

	my @variants = qw( 1H 2H );

	my @th_rows;
	my @tl_rows_kill;
	my @tl_rows_stun;

	foreach my $attack_mode (qw( Normal )) {
		my @th_row = (
			qq{<th class="SwseSheetCombatStatsSkill SwseSheetCombatStatsCellAttackMode" rowspan="2">$attack_mode</th>},
		);

		foreach my $variant_ar (@variants) {
			my($variant) = @{ $variant_ar };

			my @feat_attack_mods;
			my @feat_dmg_mods;

			my $bab_modded         = $bab + $penalty + $feat_atk_mods;
			my $kill_dmg_dice_desc = $self->describe_dice(@base_kill_dmg_dice, $feat_dmg_mods);

			push @th_row,
				qq{<th class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellAttackVariant">$variant</th>},
			);

			my @tl_row_atk = (
				qq{<td class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellAtk"><code class="writeover">$bab_modded</code></td>},
			);

			my @tl_row_kill = (
				qq{<td class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellDmg"><code class="writeover">$kill_dmg_dice_desc</code></td>},
			);
			
			my @tl_row_stun = (
				qq{<td class="SwseSheetCombatStatsCell SwseSheetCombatStatsCellDmg"><code class="writeover">$stun_dmg_dice_desc</code></td>},
			);

			push @th_rows,      join('', @th_row);
			push @th_rows_atk,  join('', @tl_row_atk);
			push @th_rows_kill, join('', @tl_row_kill);
			push @th_rows_stun, join('', @tl_row_stun);
		}
	}

	foreach my $row_ii ( 0 .. $#th_rows ) {
		$tbody .= '<tr>';
		$tbody .= $th_rows[$row_ii];
		$tbody .= $th_rows_atk[$row_ii];
		$tbody .= $th_rows_dmg[$row_ii];
		$tbody .= '</tr>';
	}

	my $breaker_class = 'SwseSheetSessionLogModLogPageBreak';
	return qq{<table class="SwseSheetCombatStatsAttackType $breaker_class">$colgroup<thead>$thead</thead><tbody>$tbody</tbody></table>};
}

1;
