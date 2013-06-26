use utf8;
use strict;
use Test::More;

use Catalyst::Test 't::lib::TestApp';

sub Dump { require YAML::Syck; goto &YAML::Syck::Dump }

{
    my $uri = URI->new("/");
    $uri->query_form( いただきます => "ごちそうさま" );

    my ($res, $c) = ctx_request($uri->as_string);

    my $params = $c->req->params;
    is_deeply($params, { いただきます => "ごちそうさま" } ) or diag Dump $c->req->params;

    is( $res->content, "Hello World!" );
}

{
    my $uri = URI->new("/");
    $uri->query_form(
        ご飯 => "Wow, it sure smells good!",
        ご飯 => "Bloody good food! Bloody good meat! Bloody good god! Let's eat!",
        ご飯 => "いただきます",
    );

    my ($res, $c) = ctx_request($uri->as_string);

    my $params = $c->req->params;
    is_deeply($params, { ご飯 => [
        "Wow, it sure smells good!",
        "Bloody good food! Bloody good meat! Bloody good god! Let's eat!",
        "いただきます",
    ] } ) or diag Dump $c->req->params;
}

# normalize
use Unicode::Normalize qw(NFC NFD);
{
    my $uri = URI->new("/");
    $uri->query_form(
        NFC("がぎぐげご") => NFC("ざじずぜぞ"),
        NFD("だぢづでど") => NFD("ぱぴぷぺぽ"),
    );

    {
        t::lib::TestApp->_normalize_hash_key_code(undef);
        t::lib::TestApp->config->{'Plugin::Unicode::Encoding::HashKey'}{normalize_hash_key_nfc} = 0;
        my ($res, $c) = ctx_request($uri->as_string);

        my @keys   = sort keys $c->req->params;
        my @values = sort values $c->req->params;
        is( length $keys[0]   ,  5 );
        is( length $keys[1]   , 10 );
        is( length $values[0] ,  5 );
        is( length $values[1] , 10 );
    }

    {
        t::lib::TestApp->_normalize_hash_key_code(undef);
        t::lib::TestApp->config->{'Plugin::Unicode::Encoding::HashKey'}{normalize_hash_key_nfc} = 1;
        my ($res, $c) = ctx_request($uri->as_string);

        my @keys   = sort keys $c->req->params;
        my @values = sort values $c->req->params;
        is( length $keys[0]   ,  5 );
        is( length $keys[1]   ,  5 );
        is( length $values[0] ,  5 );
        is( length $values[1] , 10 );
    }
}

done_testing();
