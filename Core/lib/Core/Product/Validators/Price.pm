package Core::Product::Validators::Price;

use v5.36;
use Data::Monad::Either qw/left right/;

sub valid($self, $price) {
  unless ( defined($price) ) {
    return left('Invalid price');
  }

  unless ( $price =~ /^[+-]?\d+(\.\d+)?$/ ) {
    return left('Invalid price');
  }

  unless ( $price > 0 ) {
    return left('Invalid price');
  }

  right($price);
}

1;
