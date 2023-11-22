package Core::Password::Validators::Password;

use v5.36;
use Data::Monad::Either qw/left right/;
use String::Util qw(trim);

sub valid($self, $password) {
  unless ( defined($password) ) {
    return left('Invalid password');
  }

  $password = trim($password);

  if ( length($password) < 5 || length($password) > 15 ) {
    return left('Invalid password');
  }

  unless ( $password =~ /^[a-zA-Z0-9\?\.\,\!\@\#\$\%\*\&\(\)\-\+\=\{\}\[\]\:\;\_]+$/i ) {
    return left('Invalid password');
  }

  right($password);
}

1;
