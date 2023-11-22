package Core::Jwt::Builder;

use v5.36;
use Data::Monad::Either qw/right left/;
use JSON::WebToken qw/encode_jwt/;

use Core::Shared::Validators::Email;
use Core::Jwt::Entity;

sub build($self, $args) {
  unless ($args->{access_secret}) {
    return left('Invalid access secret');
  }

  unless ($args->{refresh_secret}) {
    return left('Invalid refresh secret');
  }

  Core::Shared::Validators::Email->valid($args->{email})->flat_map(sub {
    my $access = encode_jwt({
      iss => $args->{email},
      exp => time()
    }, $args->{access_secret});

    my $refresh = encode_jwt({
      iss => $args->{email},
      exp => time() + 900
    }, $args->{refresh_secret});

    right(Core::Jwt::Entity->new({
      access => $access,
      refresh => $refresh
    }));
  });
}

1;