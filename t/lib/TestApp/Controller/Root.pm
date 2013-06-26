package t::lib::TestApp::Controller::Root;

use Moose;
BEGIN { extends qw(Catalyst::Controller) }

__PACKAGE__->config(
    namespace => "",
);

sub index :Path {
    my ($self, $c) = @_;
    $c->res->body("Hello World!");
}

1;
