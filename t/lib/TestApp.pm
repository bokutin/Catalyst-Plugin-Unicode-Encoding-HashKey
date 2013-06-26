package t::lib::TestApp;

use Moose;
extends qw(Catalyst);

__PACKAGE__->config(
    encoding => 'utf8',
);

override _default_plugins => sub { map { $_ eq "Unicode::Encoding" ? $_."::HashKey" : () } super };

__PACKAGE__->setup;

1;
