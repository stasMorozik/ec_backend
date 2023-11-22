package Core::Catalog::Validators::Name;

use v5.36;
use Data::Monad::Either qw/left right/;
use String::Util qw(trim);

sub valid($self, $catalog) {
  unless ($catalog) {
    return left('Invalid catalog');
  }

  $catalog = trim($catalog);

  unless ( $catalog =~ /^[a-zA-Z0-9\-\s]+$/i ) {
    return left('Invalid catalog');
  }

  if ( length($catalog) < 2 || length($catalog) > 15 ) {
    return left('Invalid catalog');
  }

  right($catalog);
}

1;
