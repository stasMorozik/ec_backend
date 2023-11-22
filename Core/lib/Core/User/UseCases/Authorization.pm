package Core::User::UseCases::Authorization;

use v5.36;
use fields qw(getting_user_adapter access_secret);

use Core::Jwt::Methods::Decoder;

sub new($self, $args) {
  $self = fields::new($self);

  unless ( UNIVERSAL::can($args->{getting_user_adapter}, "get") ) {
    die("Invalid adapter");
  }

  unless ($args->{access_secret}) {
    die("Invalid access secret");
  }

  $self->{getting_user_adapter} = $args->{getting_user_adapter};
  $self->{access_secret} = $args->{access_secret};

  $self;
}

sub auth($self, $args) {
  Core::Jwt::Methods::Decoder->decode({
    access_secret => $self->{access_secret},
    token => $args->{token}
  })->flat_map(sub (@args) {

    my ($email) = @args;

    $self->{getting_user_adapter}->get($email);
  
  });
}

1;
