package Mojolicious::Plugin::MethodOverride;

use Mojo::Base 'Mojolicious::Plugin';

our $VERSION = '0.041';

sub register {
    my ($self, $app, $conf) = @_;
    my $header =
        exists $conf->{header} ? $conf->{header} : 'X-HTTP-Method-Override';
    my $param = exists $conf->{param} ? $conf->{param} : undef;
    my $hook = $Mojolicious::VERSION < 3.84 ?   # support ancient Mojolicious
        'after_static_dispatch' : 'before_routes';

    $app->hook(
        $hook => sub {
            my $req = $_[0]->req;

            return unless $req->method eq 'POST';

            my $method = defined $header && $req->headers->header($header);

            if ($method) {
                $req->headers->remove($header);
            }
            elsif (defined $param) {
                for ($req->url->query) {
                    $method = $_->param($param)
                        or return 1;
                    $_->remove($param);
                }
            }

            if ($method and $method =~ /^[A-Za-z]+$/) {
                # uncoverable condition false
                $app->log->debug(($header // $param) . ': ' . $method);
                $req->method($method);
            }
        }
    );
}

1;

__END__

=head1 NAME

Mojolicious::Plugin::MethodOverride - Simulate HTTP Verbs

=head1 VERSION

Version 0.041

=head1 SYNOPSIS

  package My::App;
  use Mojo::Base 'Mojolicious';

  sub startup {
    my $self = shift;

    $self->plugin('MethodOverride');

    ...
  }

  1;

=head1 DESCRIPTION

This plugin can simulate any HTTP verb (a.k.a. HTTP method) in
environments where HTTP verbs other than GET and POST are not available.
It uses the same approach as in many other restful web frameworks, where
it replaces the C<HTTP POST> method with a method given by an C<HTTP>
header. It is also possible to define a query parameter for the same
purpose.

Any token built of US-ASCII letters is accepted as a valid value for the
HTTP verb.

=head1 CONFIGURATION

The default HTTP header to override the C<HTTP POST> method is
C<"X-HTTP-Method-Override">. Overriding through a query parameter is off
by default.

These settings can be changed in the plugin method call as demonstrated
in the examples below:

  # Mojolicious
  $self->plugin(
    MethodOverride => {
      header => 'X-Tunneled-Method',
      param  => 'x-tunneled-method',
    }
  );

  # Mojolicious::Lite
  plugin 'MethodOverride',
    header => 'X-HTTP-Method',
    param  => 'http_method';

HTTP header can be disabled by setting to C<undef>:

  # A Mojolicious app, that enables method overriding
  # by query parameter only:
  $self->plugin(
    MethodOverride => {
      header => undef,
      param  => 'x-tunneled-method',
    }
  );

=head1 AUTHOR

Bernhard Graf C<< <graf at cpan.org> >>

=head1 BUGS

Please report any bugs or feature requests to
C<bug-mojolicious-plugin-methodoverride at rt.cpan.org>, or through the
web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Mojolicious-Plugin-MethodOverride>.
I will be notified, and then you'll automatically be notified of progress
on your bug as I make changes.

=head1 SEE ALSO

L<Plack::Middleware::MethodOverride>,
L<Catalyst::TraitFor::Request::REST::ForBrowsers>,
L<HTTP::Engine::Middleware::MethodOverride>,
L<http://code.google.com/apis/gdata/docs/2.0/basics.html>

=head1 LICENSE AND COPYRIGHT

Copyright (C) 2012 - 2014 Bernhard Graf.

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

See http://dev.perl.org/licenses/ for more information.
