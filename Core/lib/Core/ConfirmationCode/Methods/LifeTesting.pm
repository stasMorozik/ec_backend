package Core::ConfirmationCode::Methods::LifeTesting;

use v5.36;
use Data::Monad::Either qw/right left/;

sub is_alive($self, $entity) {
  unless ( UNIVERSAL::isa($entity, 'Core::ConfirmationCode::Entity') ) {
    return left('Invalid code for life testing');
  }

  if ( time() <= $entity->{created} ) {
    return left('You have already confirmation code');
  }

  right(1);
}

1;