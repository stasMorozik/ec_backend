package Core::User::Entity;

use v5.36;
use fields qw(id phone email name surname created updated role);

sub new($self, $args) {
  $self = fields::new($self);

  $self->{phone} = $args->{phone};
  $self->{email} = $args->{email};
  $self->{name} = $args->{name};
  $self->{surname} = $args->{surname};
  $self->{created} = $args->{created};
  $self->{updated} = $args->{updated};
  $self->{role} = $args->{role};
  $self->{id} = $args->{id};

  $self;
}

1;