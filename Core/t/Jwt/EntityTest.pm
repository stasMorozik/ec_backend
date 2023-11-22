package Jwt::EntityTest;

use v5.36;
use Test::More;
use lib 'lib/';

use Data::Dump qw(dump);

require_ok('Core::Jwt::Builder');
require_ok('Core::Jwt::Methods::Refresher');
require_ok('Core::Jwt::Methods::Decoder');

my $either = Core::Jwt::Builder->build({
  access_secret => 'Some_secret',
  refresh_secret => 'Some_secret1',
  email => 'email@gmail.com'
});

ok($either->is_right() eq 1);

$either = Core::Jwt::Methods::Decoder->decode({
  access_secret => 'Some_secret',
  token => $either->value->{access}
});

ok($either->is_right() eq 1);

$either = Core::Jwt::Builder->build({
  access_secret => 'Some_secret',
  refresh_secret => 'Some_secret1',
  email => 'email@gmail.com'
});

$either = Core::Jwt::Methods::Refresher->refresh({
  access_secret => 'Some_secret',
  refresh_secret => 'Some_secret1',
  token => $either->value->{refresh}
});

ok($either->is_right() eq 1);

$either = Core::Jwt::Methods::Decoder->decode({
  access_secret => 'Some_secret',
  token => 'invalid token'
});

ok($either->is_left() eq 1);

$either = Core::Jwt::Builder->build({
  access_secret => 'Some_secret',
  refresh_secret => 'Some_secret1',
  email => 'email@gmail.com'
});

$either = Core::Jwt::Methods::Refresher->refresh({
  access_secret => 'Some_secret',
  refresh_secret => 'Some_secret1',
  token => 'invalid token'
});

ok($either->is_left() eq 1);

1;
