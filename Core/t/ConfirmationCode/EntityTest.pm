package ConfirmationCode::EntityTest;

use v5.36;
use Test::More;
use lib 'lib/';

use Data::Dump qw(dump);

require_ok('Core::ConfirmationCode::Builder');
require_ok('Core::ConfirmationCode::Validators::Code');
require_ok('Core::ConfirmationCode::Methods::Confirmation');
require_ok('Core::ConfirmationCode::Methods::Verification');
require_ok('Core::ConfirmationCode::Methods::LifeTesting');

my $either = Core::ConfirmationCode::Builder->build({
  email => 'georg@gmail.com',
  code => int(rand(
    Core::ConfirmationCode::Validators::Code->upper_limit() - Core::ConfirmationCode::Validators::Code->lower_limit()
  )) + Core::ConfirmationCode::Validators::Code->lower_limit()
});

ok($either->is_right() eq 1);

my $either_r = Core::ConfirmationCode::Methods::Confirmation->confirm({
  entity => $either->value, 
  code => $either->value->{code}
});

ok($either_r->is_right() eq 1);

$either_r = Core::ConfirmationCode::Methods::Verification->verify({
  entity => $either->value, 
  code => $either->value->{code}
});

ok($either_r->is_right() eq 1);

$either_r = Core::ConfirmationCode::Methods::Verification->verify({
  entity => $either->value, 
  code => 100
});

ok($either_r->is_left() eq 1);

$either_r = Core::ConfirmationCode::Methods::Verification->verify({
  entity => $either->value, 
  code => 1000
});

ok($either_r->is_left() eq 1);

$either_r = Core::ConfirmationCode::Methods::LifeTesting->is_alive($either->value);

ok($either_r->is_left() eq 1);

1;
