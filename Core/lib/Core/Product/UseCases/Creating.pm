package Core::Product::UseCases::Creating;

use v5.36;
use fields qw(authorization_use_case transformer_adapter putting_files_adapter web_dav_uri);
use Data::Monad::Either qw/left right/;
use Core::User::Methods::VerificationRole;
use Core::Product::Builder;

sub new($class, $args) {
  my $self = fields::new($class);

  unless ( UNIVERSAL::can($args->{authorization_use_case}, "auth") ) {
    die("Invalid adapter");
  }

  unless ( UNIVERSAL::can($args->{transformer_adapter}, "transform") ) {
    die("Invalid adapter");
  }

  unless ( UNIVERSAL::can($args->{putting_files_adapter}, "put") ) {
    die("Invalid adapter");
  }

  unless ( $args->{web_dav_uri} ) {
    die("Invalid web dav uri");
  }

  $self->{authorization_use_case} = $args->{authorization_use_case};
  $self->{transformer_adapter} = $args->{transformer_adapter};
  $self->{putting_files_adapter} = $args->{putting_files_adapter};

  $self->{web_dav_uri} = $args->{web_dav_uri};

  $self;
}

my $auth_user = sub ($self, $token) {
  $self->{authorization_use_case}->auth({token => $token});
};

my $verify_user_role = sub ($entity) {
  Core::User::Methods::VerificationRole->verify($entity);
};

my $build_product = sub ($args) {
  Core::Product::Builder->build($args);
};

my $put_files = sub ($self, $entity) {
  $self->{putting_files_adapter}->put($entity);
};

my $insert_entity = sub ($self, $entity) {
  $self->{transformer_adapter}->transform($entity);
};

sub create(@args) {
  my ($self, $args) = @args;

  $args->{image_path} = $self->{web_dav_uri};
  
  &$auth_user($self, $args->{token})->flat_map(sub ($user_entity) {
    &$verify_user_role($user_entity)->flat_map(sub {
      &$build_product($args)->flat_map(sub ($product_entity) {
        &$put_files($self, $product_entity)->flat_map(sub {
          &$insert_entity($self, $product_entity);
        });
      });
    });
  });
}

1;