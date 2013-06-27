# NAME

Catalyst::Plugin::Unicode::Encoding::HashKey - params のキーもデコードする。

# SYNOPSIS

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
