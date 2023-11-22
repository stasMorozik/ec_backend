package Core::Catalog::Entity;

use v5.36;
use fields qw(id name created updated elements);

sub new($self, $args) {
  $self = fields::new($self);

  $self->{id} = $args->{id};
  $self->{name} = $args->{name};
  $self->{created} = $args->{created};
  $self->{updated} = $args->{updated};
  $self->{elements} = $args->{elements};
  $self;
}

1;
