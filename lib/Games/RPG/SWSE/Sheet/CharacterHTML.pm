package Games::RPG::SWSE::Sheet::CharacterHTML;

=head1 NAME

Games::RPG::SWSE::Sheet::CharacterHTML - HTML character sheet

=head1 SYNOPSIS

=head1 DESCRIPTION

=cut

use strict;
use warnings;
use English qw( -no_match_vars );

our $VERSION = '0.00';

use Moose;
extends qw( Games::RPG::SWSE::Sheet::Character );

=head1 ATTRIBUTES

Object attributes.

=cut

has [qw( title script style header_title header_details )] => (
	'is'         => 'rw',
	'isa'        => 'Str',
	'lazy_build' => 1,
);

sub _build_title { return __PACKAGE__ }

sub _build_script
{
	return <<'EOT';
				<script  src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.js"></script>
				<script  src="script.js"></script>
EOT
}

sub _build_style
{
	return <<'EOT';
				<link   href="style.css" rel="stylesheet" type="text/css" />
				<style type="text/css">
					.SwseSheetHeader
					{
						width:         100%;
						clear:         both;
						margin-bottom: 2ex;
					}
					.SwseSheetHeader td
					{
						vertical-align: top;
						min-height:     60px;
						height:         60px;
					}
					.SwseSheetHeaderTitle
					{
						background-image:  url('star-wars-logo.png');
						background-repeat: no-repeat;
					}
					.SwseSheetHeaderDetails
					{
						padding-top: 4px;
					}
					.SwseSheetHeaderTitle h1
					{
						font-size:     0.90em;
						padding-left:  3ex;
					}
				</style>
EOT
}

sub _build_header_title
{
	my $self  = shift;
	my $c     = $self->character;
	my $title = $self->title;

	my $content = <<"EOT";
			<img src="star-wars-logo.png" />
			<h1>$title</h1>
EOT

	my $level_text  = sprintf('Heroic Level %d', $c->heroic_level);
	   $level_text .= sprintf(' / %s', $c->current_class->name) if $c->current_class;

	$content .= sprintf('<span class="SwseSheetCharName">%s</span> <span class="SwseSheetCharHL">[%s]</span>', $c->name, $level_text);
	$content .= sprintf('<span class="SwseSheetHP">Hit Points: %d</span>', $c->hit_points || 0);
	$content .= '<pre>' . $self->_dump_attr_blurbs_as_text($c, @{ $c->unique_classes || [] }) . '</pre>';

	return $content;

}

sub _build_template
{
	return <<'EOT';

		<DOCTYPE HTML />
		<html>
			<head>
				<title>
					<% $sheet->title %>
				</title>
				<% $sheet->script %>
				<% $sheet->style  %>
			</head>
			<body>
				<table class="SwseSheetHeader">
					<tbody>
						<tr>
							<td class="SwseSheetHeaderTitle">
								<% $sheet->header_title %>
							</td>
							<td class="SwseSheetHeaderDetails">
								<% $sheet->header_details %>
							</td>
						</tr>
					</tbody>
				</table>
				<% $sheet->content %>
			</body>
		</html>

<%args>
	$sheet
</%args>
EOT
}


sub _build_header_details
{
	my $self = shift;
	my $c    = $self->character;

	my $content = super();

	$content .= $self->_dump_attr_blurbs_as_text($c, @{ $c->abilities      });

	return $content;
};


sub _build_content
{
	my $self = shift;
	my $c    = $self->character;

	my $content = '';

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

no Moose; __PACKAGE__->meta->make_immutable;

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

