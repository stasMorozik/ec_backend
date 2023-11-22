package Password::EntityTest;

use v5.36;
use Test::More;
use lib 'lib/';

use Data::Dump qw(dump);

require_ok('Core::Password::Builder');
require_ok('Core::Password::Methods::Verification');

my $either = Core::Password::Builder->build({
  email => 'georg@gmail.com',
  password => '1some_password!'
});

ok($either->is_right() eq 1);

$either = Core::Password::Builder->build({
  email => 'georg@',
  password => '1some_password!'
});

ok($either->is_left() eq 1);

$either = Core::Password::Builder->build({
  email => 'georg@gmail.com'
});

ok($either->is_left() eq 1);

$either = Core::Password::Builder->build({
});

ok($either->is_left() eq 1);

$either = Core::Password::Builder->build({
  password => '1some_password!'
});

ok($either->is_left() eq 1);

$either = Core::Password::Builder->build({
  email => 'georg@gmail.com',
  password => 'яыкалыц'
});

ok($either->is_left() eq 1);

$either = Core::Password::Builder->build({
  email => 'georg@gmail.com',
  password => '1some_password!',
});

my $either_verification = Core::Password::Methods::Verification->verify({
  entity => $either->value, 
  password => '1some_password!'
});

ok($either_verification->is_right() eq 1);

$either_verification = Core::Password::Methods::Verification->verify({
  entity => $either->value, 
  password => '1some_password'
});

ok($either_verification->is_left() eq 1);

1;
