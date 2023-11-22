package Core::Product::Validators::Images;

use v5.36;
use Data::Monad::Either qw/left right/;
use Core::Product::Validators::Image;

sub valid($self, $images) {  
  unless ( ref($images) eq 'ARRAY' ) {
    return left('Invalid images');
  }

  unless ( scalar(@{ $images }) > 0 ) {
    return left('Invalid images');
  }
  
  foreach ( @{ $images } ) {
    my $either_image = Core::Product::Validators::Image->valid($_);

    if ($either_image->is_left()) {
      return $either_image;
    }
  }

  right(1);
}

1;