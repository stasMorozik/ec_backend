package Core::Product::Validators::Title;

use v5.36;
use Data::Monad::Either qw/left right/;
use String::Util qw(trim);

sub valid($self, $title) {
  unless ( defined($title) ) {
    return left('Invalid title');
  }

  $title = trim($title);

  unless ( $title =~ /^[a-zA-Z0-9\s]+$/i ) {
    return left('Invalid title');
  }

  if ( length($title) < 2 || length($title) > 30 ) {
    return left('Invalid title');
  }

  right($title);
}

1;
