package Core::Brand::Builder;

use v5.36;
use POSIX qw(strftime);
use Data::Monad::Either qw/right left/;
use Data::UUID;
use Crypt::PBKDF2;

use Core::Brand::Entity;

my $entity = sub {
  my $ug = Data::UUID->new();

  right(Core::Brand::Entity->new({
    id => $ug->to_string( $ug->create() ),
    description => '',
    name => '',
    created => strftime('%F %R', localtime() ),
    updated => strftime('%F %R', localtime() )
  }));
};

my $build_name = sub ($entity, $name) {
  Core::Brand::Validators::Name->valid($name)->flat_map(sub () {
    $entity->{name} = $name;
    right(1);
  });
};

my $build_description = sub ($entity, $description) {
  Core::Brand::Validators::Description->valid($description)->flat_map(sub {
    $entity->{description} = $description;
    right(1);
  });
};

sub build($self, $args) {  
  &$entity()->flat_map(sub ($brand_entity) {
    &$build_name($brand_entity, $args->{name})->flat_map(sub {
      &$build_description($brand_entity, $args->{description});
    });
  });
}

1;