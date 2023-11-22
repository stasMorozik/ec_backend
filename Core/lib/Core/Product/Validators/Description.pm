package Core::Product::Validators::Description;

use v5.36;
use Data::Monad::Either qw/left right/;
use String::Util qw(trim);

sub valid(@args) {
  my ($self, $description) = @args;

  unless ( defined($description) ) {
    return right('');
  }

  $description = trim($description);

  if ( length($description) > 512 ) {
    return left('Invalid description');
  }

  right($description);
}

1;
