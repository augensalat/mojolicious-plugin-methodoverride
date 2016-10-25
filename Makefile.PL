use 5.010001;

use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
    NAME         => 'Mojolicious::Plugin::MethodOverride',
    VERSION_FROM => 'lib/Mojolicious/Plugin/MethodOverride.pm',
    ABSTRACT     => 'Simulate HTTP Verbs',
    AUTHOR       => 'Bernhard Graf',
    LICENSE      => 'perl_5',
    META_MERGE   => {
        requires  => {perl => '5.010001'},
        resources => {
            license    => 'http://dev.perl.org/licenses/',
            bugtracker => 'https://github.com/augensalat/mojolicious-plugin-methodoverride/issues',
            repository => 'https://github.com/augensalat/mojolicious-plugin-methodoverride.git',
        },
    },
    PREREQ_PM    => {
        'Mojolicious' => '6.03',
    },
    test         => {TESTS => 't/*.t'},
);
