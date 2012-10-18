use inc::Module::Install;

name            'Mojolicious-Plugin-MethodOverride';
all_from        'lib/Mojolicious/Plugin/MethodOverride.pm';
readme_from;
author          q{Bernhard Graf <graf@cpan.org>};
license         'perl';
repository      'git://github.com/augensalat/mojolicious-plugin-methodoverride.git';

build_requires  'Test::More';
build_requires  'Test::Mojo';

requires        'Mojolicious' => '2.0';

auto_install;

WriteAll;

