package Core::ConfirmationCode::UseCases::Confirming;

use v5.36;
use fields qw(getting_code_adapter transformer_code_adapter);
use Data::Monad::Either qw/left right/;

use Core::Jwt::Entity qw(build);
use Core::Shared::Validators::Email;
use Core::ConfirmationCode::Validators::Code;
use Core::ConfirmationCode::Methods::Confirmation;

sub new($self, $args) {
  $self = fields::new($self);

  unless ( UNIVERSAL::can($args->{getting_code_adapter}, "get") ) {
    die("Invalid adapter");
  }

  unless ( UNIVERSAL::can($args->{transformer_code_adapter}, "transform") ) {
    die("Invalid adapter");
  }

  $self->{getting_code_adapter} = $args->{getting_code_adapter};
  $self->{transformer_code_adapter} = $args->{transformer_code_adapter};

  $self;
}

my $get_confirmation_code = sub ($self, $email) {
  Core::Shared::Validators::Email->valid($email)->flat_map(sub {
    $self->{getting_code_adapter}->get($email);
  });
};

my $confirm = sub ($entity, $code) {
  Core::ConfirmationCode::Methods::Confirmation->confirm({
    entity => $entity,
    code => $code
  })
};

my $transform = sub ($self, $entity) {
  $self->{transformer_code_adapter}->transform($entity);
};

sub confirm($self, $args) {
  &$get_confirmation_code($self, $args->{email})->flat_map(sub ($entity) {
    &$confirm($entity, $args->{code})->flat_map(sub {
      &$transform($self, $entity);
    });
  });
}

1;
