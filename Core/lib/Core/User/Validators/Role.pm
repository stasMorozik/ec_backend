package Core::User::Validators::Role;

use v5.36;
use String::Util qw(trim);
use Data::Monad::Either qw/left right/;

sub admin {
  'Administrator';
}

sub user {
  'User';
}

sub valid($self, $role) {
  unless ( defined($role) ) {
    return left('Invalid role');
  }

  $role = trim($role);

  if ( $role eq admin() ) {
    return right($role);
  }

  if ( $role eq user() ) {
    return right($role);
  }

  left('Invalid role');
}

1;
