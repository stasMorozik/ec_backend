package Core::Brand::Validators::Name;

use v5.36;
use Data::Monad::Either qw/left right/;
use String::Util qw(trim);

sub valid($self, $name) {
  unless ($name) {
    return left('Invalid name');
  }

  $name = trim($name);

  unless ( $name =~ /^[a-zA-Z0-9\-\s]+$/i ) {
    return left('Invalid name');
  }

  if ( length($name) < 2 || length($name) > 15 ) {
    return left('Invalid name');
  }

  right($name);
}

1;
