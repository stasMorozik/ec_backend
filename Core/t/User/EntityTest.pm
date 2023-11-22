package User::EntityTest;

use v5.36;
use Test::More;
use lib 'lib/';

use Data::Dump qw(dump);

require_ok('Core::User::Builder');
require_ok('Core::User::Methods::VerificationRole');

my $either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator'
});

ok($either->is_right() eq 1);

$either = Core::User::Builder->build({
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator'
});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator'
});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  phone => '+79683248682',
  role => 'Administrator'
});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  role => 'Administrator'
});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682'
});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg 1 Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator'
});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+74959594377',
  role => 'Administrator'
});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig 1',
  phone => '+79683248682',
  role => 'Administrator'
});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+',
  role => 'Administrator'
});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator1'
});

ok($either->is_left() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator'
});

$either = Core::User::Methods::VerificationRole->verify($either->value);

ok($either->is_right() eq 1);

$either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'User'
});

$either = Core::User::Methods::VerificationRole->verify($either->value);

ok($either->is_left() eq 1);

1;
