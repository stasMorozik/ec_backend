package ConfirmationCode::UseCases::CreatingByAdminTest;

use v5.36;
use Test::More;
use lib 'lib/';
use Data::Dump qw(dump);

require_ok('Core::ConfirmationCode::Builder');
require_ok('Core::ConfirmationCode::Validators::Code');
require_ok('Core::ConfirmationCode::UseCases::CreatingByAdmin');

require_ok('Core::User::UseCases::Authorization');
require_ok('Core::User::Builder');
require_ok('Core::Jwt::Builder');

package GettingUserAdapterFor {
  use fields qw(users);
  use Data::Monad::Either qw/left right/;

  sub new(@args) {
    my ($self, $args) = @args;

    $self = fields::new($self);

    $self->{users} = $args->{users};

    $self;
  }

  sub get(@args) {
    my ($self, $email) = @args;

    my $user = $self->{users}->{$email};

    unless ($user) {
      return left('User not found');
    }

    right($user);
  }

  1;
}

my $access_secret = 'access_secret';
my $refresh_secret = 'refresh_secret';

my %users = ();

my $getting_user_adapter = GettingUserAdapterFor->new({
  users => \%users
});

my $either = Core::User::Builder->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator'
});

$users{'georg@gmail.com'} = $either->value;

$either = Core::User::Builder->build({
  email => 'georg1@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'User'
});

$users{'georg1@gmail.com'} = $either->value;

$either = Core::Jwt::Builder->build({
  access_secret => $access_secret,
  refresh_secret => $refresh_secret,
  email => 'georg@gmail.com'
});

my $token_admin = $either->value;

$either = Core::Jwt::Builder->build({
  access_secret => $access_secret,
  refresh_secret => $refresh_secret,
  email => 'georg1@gmail.com'
});

my $token_user = $either->value;

my $auth_use_case = Core::User::UseCases::Authorization->new({
  getting_user_adapter => $getting_user_adapter,
  access_secret => $access_secret
});

package GettingAdapterFor {
  use fields qw(codes);
  use Data::Monad::Either qw/left right/;

  sub new(@args) {
    my ($self, $args) = @args;

    $self = fields::new($self);

    $self->{codes} = $args->{codes};

    $self;
  }

  sub get(@args) {
    my ($self, $email) = @args;

    my $code = $self->{codes}->{$email};

    unless ($code) {
      return left('Code not found');
    }

    right($code);
  }

  1;
}

package CreatingAdapterFor {
  use fields qw(codes);
  use Data::Monad::Either qw/left right/;

  sub new(@args) {
    my ($self, $args) = @args;

    $self = fields::new($self);

    $self->{codes} = $args->{codes};

    $self;
  }

  sub transform(@args) {
    my ($self, $entity) = @args;

    $self->{codes}->{
      $entity->{email}
    } = $entity;

    right(1);
  }

  1;
}

package NotifierAdapterFor {
  use fields qw();
  use Data::Dump qw(dump);

  sub new(@args) {
    my ($self, $args) = @args;

    $self = fields::new($self);

    $self;
  }

  sub notify(@args) {
    my ($self, $args) = @args;

    dump($args);
  }

  1;
}

my %codes = ();

my $either_code = Core::ConfirmationCode::Builder->build({
  email => 'georg@gmail.com',
  code => int(rand(
    Core::ConfirmationCode::Validators::Code->upper_limit() - Core::ConfirmationCode::Validators::Code->lower_limit()
  )) + Core::ConfirmationCode::Validators::Code->lower_limit()
});

my $getting_adapter = GettingAdapterFor->new({
  codes => \%codes
});

my $transformer_code_adapter = CreatingAdapterFor->new({
  codes => \%codes
});

my $notifier_adapter = NotifierAdapterFor->new();

my $use_case = Core::ConfirmationCode::UseCases::CreatingByAdmin->new({
  authorization_use_case => $auth_use_case,
  getting_code_adapter => $getting_adapter,
  transformer_code_adapter => $transformer_code_adapter,
  notifying_adapter => $notifier_adapter
});

my $either_result = $use_case->create_by_admin({
  token => $token_admin->{access},
  email => 'georg@gmail.com'
});

ok($either_result->is_right() eq 1);

$either_result = $use_case->create_by_admin({
  token => $token_user->{access},
  email => 'georg1@gmail.com'
});

ok($either_result->is_left() eq 1);

$either_result = $use_case->create_by_admin({
  token => 'Invalid token',
  email => 'georg@gmail.com'
});

ok($either_result->is_left() eq 1);

$codes{'georg@gmail.com'} = $either_code->value;

$either_result = $use_case->create_by_admin({
  token => $token_admin->{access},
  email => 'georg@gmail.com'
});

ok($either_result->is_left() eq 1);

1;