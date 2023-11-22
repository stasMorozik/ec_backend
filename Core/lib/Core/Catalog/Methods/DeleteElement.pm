package Core::Catalog::Methods::AddElement;

use v5.36;
use Data::Monad::Either qw/right left/;
use Core::Catalog::Entity;

sub del($self, $for_what, $elem) {
  unless ( UNIVERSAL::isa($elem, 'Core::Catalog::Entity') ) {
    return left('Invalid elem for adding');
  }

  unless ( UNIVERSAL::isa($for_what, 'Core::Catalog::Entity') ) {
    return left('Invalid elem for adding');
  }

  if ($for_what->{id} == $elem->{id}) {
    return left('Equal elems for adding');
  }

  @{ $for_what->{elems} } = grep { $_->{id} ne $elem->{id} } @{ $for_what->{elems} };

  @{ $for_what->{elems} } = sort { $a->{name} cmp $b->{name} } @{ $for_what->{elems} };
  
  right(1);
}

1;