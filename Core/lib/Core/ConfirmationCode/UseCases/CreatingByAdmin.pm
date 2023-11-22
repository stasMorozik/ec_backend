package Core::ConfirmationCode::UseCases::CreatingByAdmin;

use v5.36;
use base 'Core::ConfirmationCode::UseCases::Creating';
use fields qw(authorization_use_case);
use Data::Monad::Either qw/left right/;

use Core::User::Methods::VerificationRole;

sub new($class, $args) {
  my $self = fields::new($class);

  $self = $self->SUPER::new({
    getting_code_adapter => $args->{getting_code_adapter},
    transformer_code_adapter => $args->{transformer_code_adapter},
    notifying_adapter => $args->{notifying_adapter}
  });

  unless ( UNIVERSAL::can($args->{authorization_use_case}, "auth") ) {
    die("Invalid use case");
  }

  $self->{authorization_use_case} = $args->{authorization_use_case};

  $self;
}

my $auth_user = sub ($self, $token) {
  $self->{authorization_use_case}->auth({token => $token});
};

my $verify_role = sub ($user_entity) {
  Core::User::Methods::VerificationRole->verify($user_entity);
};

sub create_by_admin($self, $args) {  
  &$auth_user($self, { token => $args->{token} })->flat_map(sub ($user_entity) {
    &$verify_role($user_entity)->flat_map(sub {
      $self->create({ email => $args->{email} });
    });
  });
}

1;