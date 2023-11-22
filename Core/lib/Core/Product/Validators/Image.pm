package Core::Product::Validators::Image;

use v5.36;
use Data::Monad::Either qw/left right/;

sub valid($self, $args) {
  unless ( ref($args) eq 'HASH' ) {
    return left('Invalid image');
  }

  unless ( defined($args->{filename}) ) {
    return left('Invalid filename');
  }

  unless ( defined($args->{binary}) ) {
    return left('Invalid binary');
  }

  if ( $args->{filename} !~ /\.png$|\.jpg$|\.svg$|\.jpeg$/ ) {
    return left('Invalid type of file');
  }

  right(1);
}

1;
