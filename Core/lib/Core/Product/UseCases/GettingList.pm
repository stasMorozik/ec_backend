package Core::Product::UseCases::GettingList;

use v5.36;
use fields qw(authorization_use_case getting_list_adapter);
use Data::Monad::Either qw/left right/;
use Core::Product::Entity;

sub new($class, $args) {
  my $self = fields::new($class);

  unless ( UNIVERSAL::can($args->{authorization_use_case}, "auth") ) {
    die("Invalid adapter");
  }

  unless ( UNIVERSAL::can($args->{getting_list_adapter}, "get") ) {
    die("Invalid adapter");
  }

  $self->{authorization_use_case} = $args->{authorization_use_case};
  $self->{getting_list_adapter} = $args->{getting_list_adapter};

  $self;
}

my $auth_user = sub ($self, $token) {
  $self->{authorization_use_case}->auth({token => $token});
};

sub get($self, $args) {
  &$auth_user($self, $args->{token})->flat_map(sub (@args) {
    
  });
}

1;