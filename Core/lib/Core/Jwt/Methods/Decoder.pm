package Core::Jwt::Methods::Decoder;

use v5.36;
use Data::Monad::Either qw/right left/;
use JSON::WebToken qw/decode_jwt/;
use Try::Tiny;

sub decode($self, $args) {  
  unless ($args->{access_secret}) {
    return left('Invalid access secret');
  }

  unless ($args->{token}) {
    return left('Invalid token');
  }

  try {
    my $got = decode_jwt($args->{token}, $args->{access_secret});

    return right($got->{iss});

  } catch {
    return left('Invalid token');
  };
}

1;