package Core::ConfirmationCode::Builder;

use v5.36;
use Data::Monad::Either qw/right left/;
use Data::UUID;

use Core::ConfirmationCode::Entity;
use Core::Shared::Validators::Email;
use Core::ConfirmationCode::Validators::Code;

my $upper_limit = sub {
  Core::ConfirmationCode::Validators::Code->upper_limit();
};

my $lower_limit = sub { 
  Core::ConfirmationCode::Validators::Code->lower_limit();
};

my $code = sub {
  int(rand(&$upper_limit() - &$lower_limit())) + &$lower_limit();
};

my $entity = sub {
  my $ug = Data::UUID->new();

  right(Core::ConfirmationCode::Entity->new({
      id => $ug->to_string( $ug->create() ),
      created => time() + 86400,
      email => '',
      confirmed => 0,
      code => &$code()
  }));
};

my $build_email = sub ($entity, $email) {
  Core::Shared::Validators::Email->valid($email)->flat_map(sub {
    $entity->{email} = $email;

    right($entity);
  });
};

sub build($self, $args) {
  &$entity()->flat_map(sub ($code_entity) {
    &$build_email($code_entity, $args->{email});
  });
}

1;