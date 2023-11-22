package Core::Product::Validators::Amount;

use v5.36;
use Data::Monad::Either qw/left right/;

sub valid($self, $amount) {
  unless ( defined($amount) ) {
    return left('Invalid amount');
  }

  unless ( $amount =~ /^[+-]?\d+$/ ) {
    return left('Invalid amount');
  }

  if ( $amount < 0 ) {
    return left('Invalid amount');
  }

  right($amount);
}

1;
