package Core::Password::Builder;

use v5.36;
use POSIX qw(strftime);
use Data::Monad::Either qw/right left/;
use Data::UUID;
use Crypt::PBKDF2;

use Core::Password::Entity;
use Core::Shared::Validators::Email;
use Core::Password::Validators::Password;

my $entity = sub {
  my $ug = Data::UUID->new();

  right(
    Core::Password::Entity->new({
      email => '',
      password => '',
      id => $ug->to_string( $ug->create() ),
      created => strftime('%F %R', localtime() ),
      updated => strftime('%F %R', localtime() ),
    })
  );
};

my $build_email = sub ($entity, $email) {
  Core::Shared::Validators::Email->valid($email)->flat_map(sub {
    $entity->{email} = $email;

    right(1);
  });
};

my $build_password = sub ($entity, $password) {
  Core::Password::Validators::Password->valid($password)->flat_map(sub {
    my $hasher = Crypt::PBKDF2->new(
      hash_class => 'HMACSHA2',
      hash_args => {
        sha_size => 512,
      },
      iterations => 10000,
      salt_len => 10,
    );

    $entity->{password} = $hasher->generate($password);

    right(1);
  });
};

sub build(@args) {
  my ($self, $args) = @args;

  &$entity()->flat_map(sub ($password_entity) {
    &$build_email($password_entity, $args->{email})->flat_map(sub {
      &$build_password($password_entity, $args->{password});
    });
  });
}

1;