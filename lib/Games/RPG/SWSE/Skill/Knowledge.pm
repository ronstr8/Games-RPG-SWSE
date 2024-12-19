package Games::RPG::SWSE::Skill::Knowledge;

use strict;
use warnings;
use English qw( -no_match_vars );

use Moose;
extends qw( Games::RPG::SWSE::Skill );

around 'name_as_text_blurb' => sub {
	my $orig = shift;
	my $self = shift;

	my $name =  $self->name;
	   $name =~ s/Knowledge\s+/  / unless $name eq 'Knowledge';

	return $self->$orig(@ARG, $name);
};

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_can_use_untrained       { 1            }
sub _build_has_armor_check_penalty { 0            }

1;
