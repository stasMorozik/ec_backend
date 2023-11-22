package Core::ConfirmationCode::UseCases::Creating;

use v5.36;
use fields qw(getting_code_adapter transformer_code_adapter notifying_adapter);
use Data::Monad::Either qw/left right/;

use Core::Shared::Validators::Email;
use Core::ConfirmationCode::Builder;
use Core::ConfirmationCode::Validators::Code;
use Core::ConfirmationCode::Methods::LifeTesting;

sub new($class, $args) {
  my $self = fields::new($class);

  unless ( UNIVERSAL::can($args->{getting_code_adapter}, "get") ) {
    die("Invalid adapter");
  }

  unless ( UNIVERSAL::can($args->{transformer_code_adapter}, "transform") ) {
    die("Invalid adapter");
  }

  unless ( UNIVERSAL::can($args->{notifying_adapter}, "notify") ) {
    die("Invalid adapter");
  }

  $self->{getting_code_adapter} = $args->{getting_code_adapter};
  $self->{transformer_code_adapter} = $args->{transformer_code_adapter};
  $self->{notifying_adapter} = $args->{notifying_adapter};

  $self;
}

my $lower_limit  = sub {
  Core::ConfirmationCode::Validators::Code->lower_limit()
};

my $upper_limit = sub {
  Core::ConfirmationCode::Validators::Code->upper_limit();
};

my $get_code = sub ($self, $email) {
  Core::Shared::Validators::Email->valid($email)->flat_map(sub {
    $self->{getting_code_adapter}->get($email);
  });
};

my $test_code_life = sub ($entity) {
  Core::ConfirmationCode::Methods::LifeTesting->is_alive($entity);
};

my $build_code = sub ($email) {
  my $code = int( rand( &$upper_limit() - &$lower_limit() ) ) + &$lower_limit();

  Core::ConfirmationCode::Builder->build({
    email => $email,
    code => $code
  });
};

my $insert_entity = sub ($self, $entity) {
  $self->{transformer_code_adapter}->transform($entity);
};

my $notify = sub {
  my ($self, $email, $code) = @_;

  $self->{notifying_adapter}->notify({
    email => $email,
    subject => "Confirm email address",
    message => "Your code is $code"
  });

  right(1);
};

sub create($self, $args) {
  my $either = &$get_code($self, $args->{email});

  $either->fold(sub {
    &$build_code($args->{email})->flat_map(sub ($entity) {
      &$insert_entity($self, $entity)->flat_map( sub {
        &$notify($self, $entity->{email}, $entity->{code});
      });
    });
  }, sub ($entity) {
    &$test_code_life($entity)->flat_map(sub {
      &$insert_entity($self, $entity)->flat_map( sub {
        &$notify($self, $entity->{email}, $entity->{code});
      });
    });
  });
}

1;
