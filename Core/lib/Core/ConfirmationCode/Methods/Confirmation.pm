package Core::ConfirmationCode::Methods::Confirmation;

use v5.36;
use Data::Monad::Either qw/right left/;

use Data::Dump qw(dump);

sub confirm($self, $args) {
  unless ( UNIVERSAL::isa($args->{entity}, 'Core::ConfirmationCode::Entity') ) {
    return left('Invalid code for confirmation');
  }

  unless ($args->{code}) {
    return left('Invalid code');
  }
  
  Core::ConfirmationCode::Validators::Code->valid($args->{code})->flat_map(sub {
    if ( time() >= $args->{entity}->{created} ) {
      return left('You have already confirmation code');
    }

    unless ($args->{code} == $args->{entity}->{code}) {
      return left('Wrong code');
    }

    $args->{entity}->{confirmed} = 1;

    right(1);
  });
}

1;