package Core::Product::Validators::Feature;

use v5.36;
use Data::Monad::Either qw/left right/;
use String::Util qw(trim);

sub valid($self, $feature) {
  unless ( defined($feature) ) {
    return left('Invalid feature');
  }

  $feature = trim($feature);

  if ( length($feature) > 128 ) {
    return left('Invalid feature');
  }

  right($feature);
}

1;
