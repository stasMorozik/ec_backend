package Core::Product::Builder;

use v5.36;
use POSIX qw(strftime);
use Data::Monad::Either qw/right left/;
use Data::UUID;

use Core::Product::Entity;
use Core::Product::Validators::Title;
use Core::Product::Validators::Description;
use Core::Product::Validators::Price;
use Core::Product::Validators::Amount;
use Core::Product::Validators::Features;
use Core::Product::Validators::Image;
use Core::Product::Validators::Images;

use Data::Dump qw(dump);

my $entity = sub {
  my $ug = Data::UUID->new();

  right(
    Core::Product::Entity->new({
      id => $ug->to_string( $ug->create() ),
      created => strftime('%F %R', localtime() ),
      updated => strftime('%F %R', localtime() ),
      title => '',
      description => '',
      price => '',
      amount => '',
      article => '',
      logo => {},
      images => [],
      features => []
    })
  );
};

my $build_title = sub ($entity, $title) {
  Core::Product::Validators::Title->valid($title)->flat_map(sub {
    $entity->{title} = $title;

    right($entity);
  });
};

my $build_description = sub ($entity, $description) {
  Core::Product::Validators::Description->valid($description)->flat_map(sub {
    $entity->{description} = $description;

    right($entity);
  });
};

my $build_price = sub ($entity, $price) {
  Core::Product::Validators::Price->valid($price)->flat_map(sub {
    $entity->{price} = $price;

    right($entity);
  });
};

my $build_amount = sub ($entity, $amount) {  
  Core::Product::Validators::Amount->valid($amount)->flat_map(sub {
    $entity->{amount} = $amount;

    right($entity);
  });
};

my $build_features = sub ($entity, $features) {
  Core::Product::Validators::Features->valid($features)->flat_map(sub {
    $entity->{features} = $features;
    
    right($entity);
  });
};

my $build_images = sub {
  my ($entity, $images, $path) = @_;

  Core::Product::Validators::Images->valid($images)->flat_map(sub {
    my $ug = Data::UUID->new();

    foreach ( @{ $images } ) {
      
      my $id = $ug->to_string( $ug->create() );

      push(@{ $entity->{images} }, {
        filename => $_->{filename},
        size => length( $_->{binary} ),
        binary => $_->{binary},
        path => "$path/$id/$_->{filename}",
        id => $id
      });
    }

    right($entity);
  });
};

my $build_logo = sub {
  my ($entity, $logo, $path) = @_;

  Core::Product::Validators::Image->valid($logo)->flat_map(sub {
    my $ug = Data::UUID->new();

    my $id = $ug->to_string( $ug->create() );

    $entity->{logo} = {
      filename => $logo->{filename},
      size => length( $logo->{binary} ),
      binary => $logo->{binary},
      path => "$path/$id/$logo->{filename}",
      id => $ug->to_string( $ug->create() )
    };

    right($entity);
  });
};

my $build_article = sub ($entity, $article) {
  unless ($article) {
    return left('Invalid article');
  }

  $entity->{article} = $article;

  right($entity);
};

my $build_brand = sub ($entity, $brand) {
  unless ( UNIVERSAL::isa($brand, 'Core::Brand::Entity') ) {
    return left('Invalid brand');
  }

  $entity->{brand} = $brand;

  right($entity);
};

my $build_catalog = sub ($entity, $catalog) {
  unless ( UNIVERSAL::isa($catalog, 'Core::Catalog::Entity') ) {
    return left('Invalid catalog');
  }

  $entity->{catalog} = $catalog;

  right($entity);
};

sub build(@args) {
  my ($self, $args) = @args;

  unless ($args->{image_path}) {
    return left('Invalid image path');
  }

  my $either_0 = &$entity()->flat_map(sub ($product_entity) {
    &$build_article($product_entity, $args->{article})->flat_map(sub ($product_entity) {
      &$build_title($product_entity, $args->{title})->flat_map(sub ($product_entity) {
        &$build_description($product_entity, $args->{description});
      });
    });
  });

  my $either_1 = $either_0->flat_map(sub ($product_entity) {
    &$build_price($product_entity, $args->{price})->flat_map(sub ($product_entity) {
      &$build_amount($product_entity, $args->{amount})->flat_map(sub ($product_entity) {
        &$build_features($product_entity, $args->{features});
      });
    });
  });

  my $either_2 = $either_1->flat_map(sub ($product_entity) {
    &$build_images($product_entity, $args->{images}, $args->{image_path});
  });

  $either_2->flat_map(sub ($product_entity) {
    &$build_logo($product_entity, $args->{logo}, $args->{image_path});
  });
}

1;