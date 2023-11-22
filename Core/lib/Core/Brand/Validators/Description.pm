package Core::Brand::Validators::Description;

use v5.36;
use Data::Monad::Either qw/left right/;
use String::Util qw(trim);

sub valid($self, $description) {
  unless ($description) {
    return left('Invalid description');
  }

  $description = trim($description);

  if ( length($description) < 32 || length($description) > 512 ) {
    return left('Invalid description');
  }

  right($description);
}

1;
