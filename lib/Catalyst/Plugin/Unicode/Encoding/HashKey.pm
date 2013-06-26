package Catalyst::Plugin::Unicode::Encoding::HashKey;
# ABSTRACT: params のキーもデコードする。

use strict;
use base qw(Catalyst::Plugin::Unicode::Encoding);
use Unicode::Normalize qw(NFC);

__PACKAGE__->mk_classdata('_normalize_hash_key_code');

sub normalize_hash_key_code {
    my $c = shift;

    $c->_normalize_hash_key_code or $c->_normalize_hash_key_code(
        do {
            my $flag = $c->config->{'Plugin::Unicode::Encoding::HashKey'}{normalize_hash_key_nfc} // 0;
            $flag ? sub { NFC($_[0]) } : sub { $_[0] };
        }
    );
}

sub prepare_uploads {
    my $c = shift;

    $c->next::method(@_);

    my $enc = $c->encoding;
    return unless $enc;

    my $n = $c->normalize_hash_key_code;

    for my $key (qw(parameters query_parameters body_parameters)) {
        for (keys %{ $c->req->{$key} }) {
            $c->req->{$key}{ $n->($c->_handle_unicode_decoding($_)) } = delete $c->req->{$key}{$_};
        }
    }
}

#sub _handle_unicode_decoding {
#    my $c = shift;
#    my ($value) = @_;
#
#    if (defined $value and ref $value eq 'HASH') {
#        my $n = $c->normalize_hash_key_code;
#        for (keys %$value) {
#            $value->{ $n->($c->_handle_unicode_decoding($_)) } = delete $value->{$_};
#        }
#    }
#
#    $c->next::method(@_);
#}

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

    __PACKAGE__->config(
        'Plugin::Unicode::Encoding::HashKey' => {
            normalize_hash_key_nfc => 1, # default
        },
    );

    __PACKAGE__->setup(
        ...
    };

=cut
