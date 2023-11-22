package Core::Jwt::Entity;

use v5.36;
use fields qw( access refresh );

sub new(@args) {
  my ($self, $args) = @args;

  $self = fields::new($self);

  $self->{access} = $args->{access};
  $self->{refresh} = $args->{refresh};
  $self;
}

1;

