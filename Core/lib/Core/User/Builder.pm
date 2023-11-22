package Core::User::Builder;

use v5.36;

use POSIX qw(strftime);
use Data::Monad::Either qw/right left/;
use Data::UUID;

use Core::Shared::Validators::Email;
use Core::User::Validators::Phone;
use Core::User::Validators::Name;
use Core::User::Validators::Role;

use Core::User::Entity;

my $entity = sub {
  my $ug = Data::UUID->new();

  right(Core::User::Entity->new({
    phone => '',
    email => '',
    name => '',
    surname => '',
    created => strftime('%F %R', localtime() ),
    updated => strftime('%F %R', localtime() ),
    role => '',
    id => $ug->to_string( $ug->create() )
  }));
};

my $build_email = sub ($entity, $email) {
  Core::Shared::Validators::Email->valid($email)->flat_map(sub {
    $entity->{email} = $email;

    right(1);
  });
};

my $build_phone = sub ($entity, $phone) {
  Core::User::Validators::Phone->valid($phone)->flat_map(sub {
    $entity->{phone} = $phone;

    right(1);
  });
};

my $build_name = sub ($entity, $name) {
  Core::User::Validators::Name->valid($name)->flat_map(sub {
    $entity->{name} = $name;

    right(1);
  });
};

my $build_surname = sub ($entity, $surname) {
  Core::User::Validators::Name->valid($surname)->fold(sub {
    left('Invalid surname');
  }, sub {
    $entity->{surname} = $surname;

    right(1);
  });
};

my $build_role = sub ($entity, $role) {
  Core::User::Validators::Role->valid($role)->flat_map(sub {
    $entity->{role} = $role;

    right(1);
  });
};

sub build($self, $args) {  
  &$entity()->flat_map(sub ($user_entity) {
    &$build_email($user_entity, $args->{email})->flat_map(sub {
      &$build_phone($user_entity, $args->{phone})->flat_map(sub {
        &$build_name($user_entity, $args->{name})->flat_map(sub {
          &$build_surname($user_entity, $args->{surname})->flat_map(sub {
            &$build_role($user_entity, $args->{role});
          });
        });
      });
    });
  });
}

1;