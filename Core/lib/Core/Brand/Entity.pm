package Core::Brand::Entity;

use v5.36;
use fields qw(id name description created updated);

sub new($self, $args) {
  $self = fields::new($self);

  $self->{id} = $args->{id};
  $self->{name} = $args->{name};
  $self->{description} = $args->{description};
  $self->{created} = $args->{created};
  $self->{updated} = $args->{updated};

  $self;
}

1;
