package Core::ConfirmationCode::Methods::Verification;

use v5.36;
use Data::Monad::Either qw/right left/;

use Core::ConfirmationCode::Validators::Code;

sub verify($self, $args) {
  unless ( UNIVERSAL::isa($args->{entity}, 'Core::ConfirmationCode::Entity') ) {
    return left('Invalid code for confirmation');
  }

  unless ($args->{code}) {
    return left('Invalid code');
  }
  
  Core::ConfirmationCode::Validators::Code->valid($args->{code})->flat_map(sub {
    unless ($args->{entity}->{confirmed}) {
      return left('Not confirmed');
    }

    unless ($args->{code} == $args->{entity}->{code}) {
      return left('Wrong code');
    }

    right(1);
  });
}

1;