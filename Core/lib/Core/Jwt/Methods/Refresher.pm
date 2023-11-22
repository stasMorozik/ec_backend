package Core::Jwt::Methods::Refresher;

use v5.36;
use Data::Monad::Either qw/left/;
use JSON::WebToken qw/decode_jwt/;
use Try::Tiny;

sub refresh(@args) {
  my ($self, $args) = @args;

  unless ($args->{refresh_secret}) {
    return left('Invalid refresh secret');
  }

  unless ($args->{token}) {
    return left('Invalid token');
  }

  try {
    my $got = decode_jwt($args->{token}, $args->{refresh_secret});

    return Core::Jwt::Builder->build({
      email => $got->{iss},
      access_secret => $args->{access_secret},
      refresh_secret => $args->{refresh_secret}
    });

  } catch {
    return left('Invalid token');
  };
}

1;