package Games::RPG::SWSE::Sheet::CharacterPlainText;

=head1 NAME

Games::RPG::SWSE::Sheet::CharacterPlainText - Plain text character sheet

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Moose;
extends qw( Games::RPG::SWSE::Sheet::Character );

no Moose; __PACKAGE__->meta->make_immutable;

sub _build_content
{
	my $self = shift;
	my $c    = $self->character;

	my $content = '';

	my $level_text  = sprintf('Heroic Level %d', $c->heroic_level);
	   $level_text .= sprintf(' / %s', $c->current_class->name) if $c->current_class;

	$content .= sprintf("%s [%s]\n", $c->name, $level_text);
## 	$content .= sprintf("Hit Points: %d | Damage Threshold: %s\n",
## 		$c->hit_points       ||  0,
## 		$c->damage_threshold || '',
## 	);
## 
##	$content .= sprintf("Damage Reduction: %s\n", $c->damage_reduction || '');
##	$content .= sprintf("Shield Rating: %s\n",    $c->shield_rating    || '');

	$content .= $self->_dump_attr_blurbs_as_text($c, @{ $c->physicals });

	$content .= $self->_dump_attr_blurbs_as_text($c, @{ $c->unique_classes || [] });
	$content .= $self->_dump_attr_blurbs_as_text($c, @{ $c->abilities      });
	$content .= $self->_dump_attr_blurbs_as_text($c, @{ $c->attack_bonuses });
	$content .= $self->_dump_attr_blurbs_as_text($c, @{ $c->defenses       });
	$content .= $self->_dump_attr_blurbs_as_text($c, @{ $c->skills         });
	$content .= $self->_dump_attr_blurbs_as_text($c, @{ $c->feats          });
	$content .= $self->_dump_attr_blurbs_as_text($c, @{ $c->talents        });

	return $content;
}


sub _dump_attr_blurbs_as_text
{
	my($self, $char, @attr) = @ARG;

	my $content = "\n";
	$content .= $ARG->as_text_blurb($char) . "\n" for @attr;

	return $content;
}

## vim: foldmethod=marker

1;

__END__

=head1 SEE ALSO

=over

=item * L<Games::RPG::SWSE::Sheet> - Base gameplay aid class

=back

=head1 AUTHOR

Ron "Quinn" Straight E<lt>quinnfazigu@gmail.comE<gt>

=head1 COPYRIGHT AND LICENSE

Public domain.  Free to use and distribute, attribution appreciated.

=cut

package Games::RPG::SWSE::Sheet::AsPlainText;

=head1 NAME

Games::RPG::SWSE::Sheet::HTML - Role for text rendering of a sheet

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Carp;

use Moose::Role;

=head1 ATTRIBUTES

Object attributes.

=cut

no Moose::Role;


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



