package Core::Brand::UseCases::Creating;

use v5.36;
use fields qw(authorization_use_cases transformer_adapter);
use Data::Monad::Either qw/left right/;
use Core::Brand::Builder;
use Core::User::Methods::VerificationRole;

sub new($class, $args) {
  my $self = fields::new($class);

  unless ( UNIVERSAL::can($args->{authorization_use_case}, "auth") ) {
    die("Invalid adapter");
  }

  unless ( UNIVERSAL::can($args->{transformer_adapter}, "transform") ) {
    die("Invalid adapter");
  }

  $self->{authorization_use_case} = $args->{authorization_use_case};
  $self->{transformer_adapter} = $args->{transformer_adapter};

  $self;
}

my $auth_user = sub ($self, $token) {
  $self->{authorization_use_case}->auth({token => $token});
};

my $verify_role = sub ($user_entity) {
  Core::User::Methods::VerificationRole->verify($user_entity);
};

my $build_brand = sub ($args) {
  Core::Brand::Builder->build($args);
};

my $insert_entity = sub ($self, $entity) {
  $self->{transformer_adapter}->transform($entity);
};

sub create(@args) {
  my ($self, $args) = @args;

  $args->{image_path} = $self->{web_dav_uri};
  
  &$auth_user($self, $args->{token})->flat_map(sub ($user_entity) {
    &$verify_role($user_entity)->flat_map(sub {
      &$build_brand($args)->flat_map(sub ($brand_entity) {
        &$insert_entity($self, $brand_entity);
      });
    });
  });
}

1;