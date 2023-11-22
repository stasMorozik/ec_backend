package Core::Jwt::UseCases::Refreshing;

use v5.36;
use fields qw(access_secret refresh_secret);

use Core::Jwt::Methods::Refresher;

sub new($self, $args) {
  $self = fields::new($self);

  unless ($args->{access_secret}) {
    die("Invalid access secret");
  }

  unless ($args->{refresh_secret}) {
    die("Invalid refresh secret");
  }

  $self->{access_secret} = $args->{access_secret};
  $self->{refresh_secret} = $args->{refresh_secret};

  $self;
}

sub refresh($self, $args) {
  Core::Jwt::Methods::Refresher->refresh({
    token => $args->{token},
    access_secret => $self->{access_secret},
    refresh_secret => $self->{refresh_secret}
  });
}

1;
