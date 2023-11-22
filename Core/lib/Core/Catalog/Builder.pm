package Core::Catalog::Builder;

use v5.36;
use POSIX qw(strftime);
use Data::Monad::Either qw/right left/;
use Data::UUID;
use Crypt::PBKDF2;

use Core::Catalog::Entity;

my $entity = sub {
  my $ug = Data::UUID->new();

  right(Core::Catalog::Entity->new({
    id => $ug->to_string( $ug->create() ),
    name => '',
    created => strftime('%F %R', localtime() ),
    updated => strftime('%F %R', localtime() ),
    elements => []
  }));
};

my $build_name = sub ($entity, $name) {
  Core::Catalog::Validators::Name->valid($name)->flat_map(sub {
    $entity->{name} = $name;

    right($entity);
  });
};

sub build($self, $args) {  
  &$entity()->flat_map(sub ($brand_entity) {
    &$build_name($brand_entity, $args->{name});
  });
}

1;