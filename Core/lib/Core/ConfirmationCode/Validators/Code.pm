package Core::ConfirmationCode::Validators::Code;

use v5.36;
use Data::Monad::Either qw/left right/;

sub lower_limit {
  1000;
}

sub upper_limit {
  9999;
}

sub valid($self, $code) {
  unless ( defined($code) ) {
    return left('Invalid code');
  }

  unless ( $code =~ /^[+-]?\d+$/ ) {
    return left('Invalid code');
  }

  if ( $code < lower_limit() || $code > upper_limit() ) {
    return left('Invalid code');
  }

  right($code);
}

1;
