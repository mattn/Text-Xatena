package Text::Xatena::Node;

use strict;
use warnings;
use overload
    '@{}' => \&children,
    fallback => 1;

sub new {
    my ($class, $children) = @_;
    bless {
        children => $children || [],
    }, $class;
}

sub children { $_[0]->{children} };

sub inline {
    my ($self, $text, %opts) = @_;
    $text =~ s{^\n}{}g;
    $text = $opts{inline}->format($text);
}

sub as_html {
    my ($self, %opts) = @_;
    my $ret = "";

    my $children = $_[0]->{children};
    my @texts;
    for my $child (@$children) {
        if (ref($child)) {
            $ret .= $self->as_html_paragraph(join("\n", @texts), %opts) if join '', @texts;
            @texts = ();
            $ret .= $child->as_html(%opts);
        } else {
            push @texts, $child;
        }
    }
    $ret .= $self->as_html_paragraph(join("\n", @texts), %opts) if join '', @texts;

    $ret;
}

## NOT COMPATIBLE WITH Hatena Syntax: Auto br insertation as \n
sub as_html_paragraph {
    my ($self, $text, %opts) = @_;
    $text = $self->inline($text, %opts);

    if ($opts{stopp}) {
        $text;
    } else {
        "<p>" . join("",
            map {
                if (/^(\n+)$/) {
                    "</p>" . ("<br />\n" x (length($1) - 2)) . "<p>";
                } else {
                    join("<br />\n", split /\n/);
                }
            }
            split(/(\n\n+)/, $text)
        ) . "</p>\n";
    }
}


1;
__END__



