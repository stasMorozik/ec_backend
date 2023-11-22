package Core::Product::Entity;

use v5.36;
use fields qw(
  id 
  title 
  description 
  features 
  created
  updated 
  price 
  amount 
  images 
  logo 
  article 
  brand
  catalog
);

sub new($self, $args) {
  $self = fields::new($self);

  $self->{title} = $args->{title};
  $self->{description} = $args->{description};
  $self->{features} = $args->{features};
  $self->{created} = $args->{created};
  $self->{updated} = $args->{updated};
  $self->{price} = $args->{price};
  $self->{amount} = $args->{amount};
  $self->{logo} = $args->{logo};
  $self->{images} = $args->{images};
  $self->{id} = $args->{id};
  $self->{brand} = $args->{brand};
  $self->{catalog} = $args->{catalog};

  $self;
}

1;
