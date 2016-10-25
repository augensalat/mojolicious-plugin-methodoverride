#!/usr/bin/env perl

use Mojo::Base -strict;

# Disable IPv6 and libev
BEGIN {
    $ENV{MOJO_NO_IPV6} = 1;
    $ENV{MOJO_REACTOR} = 'Mojo::Reactor::Poll';
}

use Test::More;
 
use Mojolicious::Lite;
use Test::Mojo;

plugin 'MethodOverride';

app->secrets(['mpmo.test']);

{
    no strict 'refs';

    for my $method (qw(get post put del)) {
        $method->('/welcome' => sub {
            shift->render(
                data => "$method the Mojolicious real-time web framework!\n"
            );
        });
    }
}

my $t = Test::Mojo->new;

$t->get_ok('/welcome')
  ->status_is(200)
  ->content_like(qr/get the Mojolicious /);
$t->post_ok('/welcome')
  ->status_is(200)
  ->content_like(qr/post the Mojolicious /);
$t->put_ok('/welcome')
  ->status_is(200)
  ->content_like(qr/put the Mojolicious /);
$t->delete_ok('/welcome')
  ->status_is(200)
  ->content_like(qr/del the Mojolicious /);

$t->post_ok('/welcome', {'X-HTTP-Method-Override' => 'GET'})
  ->status_is(200)
  ->content_like(qr/get the Mojolicious /);
$t->post_ok('/welcome', {'X-HTTP-Method-Override' => 'POST'})
  ->status_is(200)
  ->content_like(qr/post the Mojolicious /);
$t->post_ok('/welcome', {'X-HTTP-Method-Override' => 'PUT'})
  ->status_is(200)
  ->content_like(qr/put the Mojolicious /);
$t->post_ok('/welcome', {'X-HTTP-Method-Override' => 'DELETE'})
  ->status_is(200)
  ->content_like(qr/del the Mojolicious /);

$t->post_ok('/welcome', {'X-HTTP-Bogus-Override' => 'PUT'})
  ->status_is(200)
  ->content_unlike(qr/put the Mojolicious /)
  ->content_like(qr/post the Mojolicious /);

done_testing;
