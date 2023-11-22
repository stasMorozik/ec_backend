package Core::Password::Entity;

use v5.36;
use fields qw(id email password created updated);

sub new($self, $args) {
  $self = fields::new($self);

  $self->{email} = $args->{email};
  $self->{password} = $args->{password};
  $self->{created} = $args->{created};
  $self->{updated} = $args->{updated};
  $self->{id} = $args->{id};

  $self;
}

1;
