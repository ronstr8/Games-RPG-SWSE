# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name            'Games-RPG-SWSE';
all_from        'lib/Games/RPG/SWSE.pm';

# Specific dependencies

requires 'Moose';
requires 'HTML::Mason';
requires 'UNIVERSAL::require';

build_requires 'Module::Install' => '0';
build_requires 'Test::Most'      => '0';

tests( 't/*.t' );

auto_install;
WriteAll;

