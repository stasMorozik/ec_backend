package Core::Product::Validators::Features;

use v5.36;
use Data::Monad::Either qw/left right/;

use Core::Product::Validators::Feature;
use Core::Product::Validators::Title;

sub valid($self, $features) {
  unless ( ref($features) eq 'ARRAY' ) {
    return left('Invalid features');
  }

  unless ( scalar(@{ $features }) > 0 ) {
    return left('Invalid features');
  }

  foreach ( @{ $features } ) {
    unless ( ref($_) eq 'HASH' ) {
      return left('Invalid feature');
    }

    unless ( ref($_->{features}) eq 'ARRAY' ) {
      return left('Invalid feature');
    }

    unless ( scalar(@{ $_->{features} }) > 0 ) {
      return left('Invalid features');
    }

    my $either_title = Core::Product::Validators::Title->valid($_->{title});
    
    if ($either_title->is_left()) {
      return $either_title;
    }

    foreach ( @{ $_->{features} } ) {
      unless ( ref($_) eq 'HASH' ) {
        return left('Invalid feature');
      }

      my $either_title = Core::Product::Validators::Title->valid($_->{title});

      if ($either_title->is_left()) {
        return $either_title;
      }

      my $either_feature = Core::Product::Validators::Feature->valid($_->{text});

      if ($either_feature->is_left()) {
        return $either_feature;
      }
    }
  }

  right(1);
}

1;
