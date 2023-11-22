package Core::Shared::Validators::Email;

use v5.36;
use Email::Valid;
use Data::Monad::Either qw/left right/;
use String::Util qw(trim);

sub valid($self, $email) {
  unless ( defined($email) ) {
    return left('Invalid email');
  }

  $email = trim($email);

  unless( Email::Valid->address($email) ) {
    return left('Invalid email');
  }

  right($email);
}

1;
