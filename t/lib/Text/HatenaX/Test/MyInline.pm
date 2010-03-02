package Text::HatenaX::Test::MyInline;
use strict;
use warnings;
use Text::HatenaX::Inline qw(match);
use base qw(Text::HatenaX::Inline);

match qr{\@([a-z0-9]+)} => sub {
    my ($self, $twitter_id) = @_;
    sprintf('<a href="http://twitter.com/%s">@%s</a>',
        $twitter_id,
        $twitter_id,
    );
};

match qr{TEST} => sub {
    my ($self) = @_;
    "XXXX"
};

1;