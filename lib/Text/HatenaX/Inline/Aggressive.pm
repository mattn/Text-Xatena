package Text::HatenaX::Inline::Aggressive;

use strict;
use warnings;
use URI::Escape;
use LWP::Simple qw($ua);
use HTML::Entities;
use Text::HatenaX::Inline -Base;

sub cache { $_[0]->{cache} }

match qr<\[((?:https?|ftp)://[^\s:]+)(:(?:title(?:=([^[]+))?|barcode))?\]>i => sub {
    my ($self, $uri, $opt, $title) = @_;

    if ($opt) {
        if ($opt =~ /^:barcode$/) {
            return sprintf('<img src="http://chart.apis.google.com/chart?chs=150x150&cht=qr&chl=%s" title="%s"/>',
                uri_escape($uri),
                $uri,
            );
        }
        if ($opt =~ /^:title/) {
            if (!$title) {
                $title = $self->cache->get($uri);
                if (not defined $title) {
                    my $res = $ua->get($uri);
                    ($title) = ($res->content =~ qr|<title[^>]*>([^<]*)</title>|i);
                    $self->cache->set($uri, $title, "30 days");
                }
            }
            return sprintf('<a href="%s">%s</a>',
                $uri,
                encode_entities($title)
            );
        }
    } else {
        return sprintf('<a href="%s">%s</a>',
            $uri,
            $uri
        );
    }

};




1;
__END__



