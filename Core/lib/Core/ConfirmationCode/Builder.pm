package Core::ConfirmationCode::Builder;

use v5.36;
use Data::Monad::Either qw/right left/;
use Data::UUID;

use Core::ConfirmationCode::Entity;
use Core::Shared::Validators::Email;
use Core::ConfirmationCode::Validators::Code;

my $entity = sub {
  my $ug = Data::UUID->new();

  right(Core::ConfirmationCode::Entity->new({
      id => $ug->to_string( $ug->create() ),
      created => time() + 86400,
      email => '',
      confirmed => 0,
      code => 0
  }));
};

my $build_email = sub ($entity, $email) {
  Core::Shared::Validators::Email->valid($email)->flat_map(sub {
    $entity->{email} = $email;

    right($entity);
  });
};

my $build_code = sub ($entity, $code) {
  Core::ConfirmationCode::Validators::Code->valid($code)->flat_map(sub {
    $entity->{code} = $code;

    right($entity);
  });
};

sub build($self, $args) {
  &$entity(sub ($code_entity) {
    &$build_email($code_entity, $args->{email})->flat_map(sub {
      &$build_code($code_entity, $args->{code});
    });
  });
}

1;