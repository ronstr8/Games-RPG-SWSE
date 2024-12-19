
use strict;
use warnings;
use English qw( -no_match_vars );

use t::lib::Library;

use Test::Most;

use Games::RPG::SWSE::Ability;
use Games::RPG::SWSE::Character;

my $dummy   = Games::RPG::SWSE::Character->new;
my $ability = Games::RPG::SWSE::Ability->new('id' => 'FOO', 'character' => $dummy);

my %expected = (
	 1 => -5,
	 2 => -4,
	 3 => -4,
	 4 => -3,
	 5 => -3,
	 6 => -2,
	 7 => -2,
	 8 => -1,
	 9 => -1,
	10 =>  0,
	11 =>  0,
	12 =>  1,
	13 =>  1,
	14 =>  2,
	15 =>  2,
	16 =>  3,
	17 =>  3,
	18 =>  4,
	19 =>  4,
	20 =>  5,
	21 =>  5,
	27 =>  8,
	30 => 10,
);

foreach my $score (sort { $a <=> $b } keys %expected) {
	$ability->score($score);
	my $expected_modifier = $expected{$score};

	is($ability->modifier, $expected_modifier,
		"Score of $score has expected modifier $expected_modifier.");
}

done_testing;

