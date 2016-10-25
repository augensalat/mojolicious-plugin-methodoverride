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

plugin 'MethodOverride', header => 'X-HTTP-Test-Override';

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

$t->post_ok('/welcome', {'X-HTTP-Test-Override' => 'GET'})
  ->status_is(200)
  ->content_like(qr/get the Mojolicious /);
$t->post_ok('/welcome', {'X-HTTP-Test-Override' => 'POST'})
  ->status_is(200)
  ->content_like(qr/post the Mojolicious /);
$t->post_ok('/welcome', {'X-HTTP-Test-Override' => 'PUT'})
  ->status_is(200)
  ->content_like(qr/put the Mojolicious /);
$t->post_ok('/welcome', {'X-HTTP-Test-Override' => 'DELETE'})
  ->status_is(200)
  ->content_like(qr/del the Mojolicious /);

$t->post_ok('/welcome', {'X-HTTP-Method-Override' => 'PUT'})
  ->status_is(200)
  ->content_unlike(qr/put the Mojolicious /)
  ->content_like(qr/post the Mojolicious /);

$t->post_ok('/welcome?_method=GET')
  ->status_is(200)
  ->content_like(qr/get the Mojolicious /);
$t->post_ok('/welcome?_method=POST')
  ->status_is(200)
  ->content_like(qr/post the Mojolicious /);
$t->post_ok('/welcome?_method=PUT')
  ->status_is(200)
  ->content_like(qr/put the Mojolicious /);
$t->post_ok('/welcome?_method=DELETE')
  ->status_is(200)
  ->content_like(qr/del the Mojolicious /);

# parameter wins
$t->post_ok('/welcome?_method=GET', {'X-HTTP-Test-Override' => 'PUT'})
  ->status_is(200)
  ->content_unlike(qr/put the Mojolicious /)
  ->content_like(qr/get the Mojolicious /);

done_testing;
