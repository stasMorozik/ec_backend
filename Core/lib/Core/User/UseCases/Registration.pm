package Core::User::UseCases::Registration;

use v5.36;
use fields qw(transformer_adapter getting_code_adapter notifying_adapter);
use Data::Monad::Either qw/left right/;

use Core::User::Builder;
use Core::Password::Builder;
use Core::ConfirmationCode::Methods::Verification;
use Core::Shared::Validators::Email;

sub new($self, $args) {
  $self = fields::new($self);

  

  unless ( UNIVERSAL::can($args->{transformer_adapter}, "transform") ) {
    die("Invalid adapter");
  }

  unless ( UNIVERSAL::can($args->{getting_code_adapter}, "get") ) {
    die("Invalid adapter");
  }

  unless ( UNIVERSAL::can($args->{notifying_adapter}, "notify") ) {
    die("Invalid adapter");
  }

  $self->{transformer_adapter} = $args->{transformer_adapter};
  $self->{getting_code_adapter} = $args->{getting_code_adapter};
  $self->{notifying_adapter} = $args->{notifying_adapter};

  $self;
}

my $get_confirmation_code = sub ($self, $email) {
  Core::Shared::Validators::Email->valid($email)->flat_map(sub {
    $self->{getting_code_adapter}->get($email);
  });
};

my $build_user = sub ($args) {
  Core::User::Builder->build($args);
};

my $build_password = sub ($args) {
  Core::Password::Builder->build($args);
};

my $verify_code = sub ($entity, $code) {
  Core::ConfirmationCode::Methods::Verification->verify({
    entity => $entity,
    code => $code
  });
};

my $insert_entities = sub {
  my (
    $self, 
    $user_entity, 
    $password_entity, 
    $confirmation_code_entity
  ) = @_;

  $self->{transformer_adapter}->transform({
    user_entity => $user_entity,
    password_entity => $password_entity,
    confirmation_code_entity => $confirmation_code_entity
  });
};

my $notify = sub {
  my ($self, $email, $message) = @_;

  $self->{notifying_adapter}->notify({
    email => $email,
    subject => "Welcome",
    message => $message
  });

  right(1);
};

sub registry($self, $args) {  
  my $either = &$get_confirmation_code($self, $args->{email});

  $either->flat_map(sub ($code_entity) {
    &$verify_code($code_entity, $args->{confirmation_code})->flat_map(sub {
      &$build_user($args)->flat_map(sub ($user_entity) {
        &$build_password($args)->flat_map(sub ($password_entity) {
          &$insert_entities($self, $user_entity, $password_entity, $code_entity)->flat_map(sub {
            &$notify($self, $args->{email}, "Welcome $args->{email}");
          });
        });
      });
    });
  });
}

1;
