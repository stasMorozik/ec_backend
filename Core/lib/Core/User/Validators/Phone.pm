package Core::User::Validators::Phone;

use v5.36;
use Number::Phone;
use Data::Monad::Either qw/left right/;
use String::Util qw(trim);

sub valid($self, $phone) {
  unless ( defined($phone) ) {
    return left('Invalid phone');
  }

  $phone = trim($phone);

  my $maybe_phone = Number::Phone->new($phone);
  unless ( $maybe_phone ) {
    return left('Invalid phone');
  }

  unless ( $maybe_phone->is_mobile() ) {
    return left('Invalid phone');
  }

  right($phone);
}

1;
