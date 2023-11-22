package Core::User::Methods::VerificationRole;

use v5.36;
use Core::User::Validators::Role;
use Data::Monad::Either qw/right left/;

sub verify($self, $entity) {
  unless ( UNIVERSAL::isa($entity, 'Core::User::Entity') ) {
    return left('Invalid user for verification role');
  }

  unless ( $entity->{role} eq Core::User::Validators::Role->admin() ) {
    return left('You are not administrator');
  }

  right(1);
}

1;