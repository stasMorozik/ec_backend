package Core::ConfirmationCode::Entity;

use v5.36;
use fields qw(id email code confirmed created);
use Data::Monad::Either qw/right left/;
use Data::UUID;

use Core::Shared::Validators::Email;
use Core::ConfirmationCode::Validators::Code;

sub new($self, $args) {
  $self = fields::new($self);

  $self->{email} = $args->{email};
  $self->{code} = $args->{code};
  $self->{created} = $args->{created};
  $self->{id} = $args->{id};
  $self->{confirmed} = $args->{confirmed};

  $self;
}

1;
