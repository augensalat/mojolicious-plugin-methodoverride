use inc::Module::Install;

name            'Mojolicious-Plugin-MethodOverride';
all_from        'lib/Mojolicious/Plugin/MethodOverride.pm';
readme_from;
author          q{Bernhard Graf <graf@cpan.org>};
license         'perl';
repository      'http://github.com/augensalat/Mojolicious-Plugin-MethodOverride/tree/master';

build_requires  'Test::More';
build_requires  'Test::Mojo';

requires        'Mojolicious';

auto_install;

WriteAll;

