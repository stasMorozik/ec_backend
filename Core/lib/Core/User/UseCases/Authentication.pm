package Core::User::UseCases::Authentication;

use v5.36;
use fields qw(getting_password_adapter access_secret refresh_secret);
use Data::Monad::Either qw/left right/;

use Core::Jwt::Builder;
use Core::Password::Methods::Verification;
use Core::Shared::Validators::Email;

sub new($self, $args) {
  $self = fields::new($self);

  unless ( UNIVERSAL::can($args->{getting_password_adapter}, "get") ) {
    die("Invalid adapter");
  }

  unless ($args->{access_secret}) {
    die("Invalid access secret");
  }

  unless ($args->{refresh_secret}) {
    die("Invalid refresh secret");
  }

  $self->{getting_password_adapter} = $args->{getting_password_adapter};
  $self->{access_secret} = $args->{access_secret};
  $self->{refresh_secret} = $args->{refresh_secret};

  $self;
}

my $get_user = sub ($self, $email) {
  Core::Shared::Validators::Email->valid($email)->flat_map(sub {
    $self->{getting_password_adapter}->get($email);
  });
};

my $verify_password = sub ($entity, $password) {
  Core::Password::Methods::Verification->verify({
    entity => $entity,
    password => $password
  });
};

my $build_jwt = sub ($self, $email) {
  Core::Jwt::Builder->build({
    email => $email,
    access_secret => $self->{access_secret},
    refresh_secret => $self->{refresh_secret}
  });
};

sub auth(@args) {
  my ($self, $args) = @args;

  &$get_user($self, $args->{email})->flat_map(sub ($user_entity) {
    &$verify_password($user_entity, $args->{password})->flat_map(sub {
      &$build_jwt($self, $args->{email});
    });
  });
}

1;
