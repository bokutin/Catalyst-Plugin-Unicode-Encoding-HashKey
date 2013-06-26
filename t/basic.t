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

done_testing();
