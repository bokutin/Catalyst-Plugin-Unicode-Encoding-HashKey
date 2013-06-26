package Catalyst::Plugin::Unicode::Encoding::HashKey;
# ABSTRACT: params のキーもデコードする。

use strict;
use base qw(Catalyst::Plugin::Unicode::Encoding);

sub prepare_uploads {
    my $c = shift;

    $c->next::method(@_);

    my $enc = $c->encoding;
    return unless $enc;

    for my $key (qw(parameters query_parameters body_parameters)) {
        for (keys %{ $c->req->{$key} }) {
            $c->req->{$key}{ $c->_handle_unicode_decoding($_) } = delete $c->req->{$key}{$_};
        }
    }
}

sub _handle_unicode_decoding {
    my $c = shift;
    my ($value) = @_;

    if (defined $value and ref $value eq 'HASH') {
        for (keys %$value) {
            $value->{ $c->_handle_unicode_decoding($_) } = delete $value->{$_};
        }
    }

    $c->next::method(@_);
}

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Catalyst::Plugin::Unicode::Encoding::HashKey - params のキーもデコードする。

=head1 SYNOPSIS

    package YourApp;
    use Moose;
    extends qw(Catalyst);

    override _default_plugins => sub { map { $_ eq "Unicode::Encoding" ? $_."::HashKey" : () } super };

    __PACKAGE__->setup(
        ...
    };

=cut
