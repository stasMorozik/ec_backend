package User::UseCases::RegistrationTest;

use v5.36;
use Test::More;
use lib 'lib/';
use Data::Monad::Either qw/left right/;

require_ok('Core::User::UseCases::Registration');
require_ok('Core::ConfirmationCode::Builder');
require_ok('Core::ConfirmationCode::Validators::Code');
require_ok('Core::ConfirmationCode::Methods::Confirmation');

package CreatingUserPasswordAdapter {
  use fields qw(users passwords codes);
  use Data::Monad::Either qw/left right/;

  sub new(@args) {
    my ($self, $args) = @args;

    $self = fields::new($self);

    $self->{users} = $args->{users};
    $self->{passwords} = $args->{passwords};
    $self->{codes} = $args->{codes};

    $self;
  }

  sub transform(@args) {
    my ($self, $args) = @args;

    delete $self->{codes}->{
      $args->{confirmation_code_entity}->{email}
    };

    $self->{users}->{
      $args->{user_entity}->{email}
    } = $args->{user_entity};

    $self->{passwords}->{
      $args->{password_entity}->{email}
    } = $args->{password_entity};

    right(1);
  }

  1;
}

package GettingConfirmationCodeAdapter {
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
      return left('Confirmation code not found');
    }

    right($code);
  }

  1;
}

package NotifyingAdapter {
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

my %users = ();
my %passwords = ();
my %codes = ();

my $inserting_adapter = CreatingUserPasswordAdapter->new({
  users => \%users,
  passwords => \%passwords,
  codes => \%codes
});

my $getting_confirmation_code_adapter = GettingConfirmationCodeAdapter->new({
  codes => \%codes
});

my $notifying_adapter = NotifyingAdapter->new();

my $use_case = Core::User::UseCases::Registration->new({
  transformer_adapter => $inserting_adapter,
  getting_code_adapter => $getting_confirmation_code_adapter,
  notifying_adapter => $notifying_adapter
});

my $either = Core::ConfirmationCode::Builder->build({
  email => 'georg@gmail.com'
});

Core::ConfirmationCode::Methods::Confirmation->confirm({
  entity => $either->value, 
  code => $either->value->{code}
});

$codes{'georg@gmail.com'} = $either->value;

$either = $use_case->registry({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator',
  password => '123456',
  confirmation_code => $either->value->{code}
});

ok($either->is_right() eq 1);

$either = $use_case->registry({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator',
  password => '123456',
  confirmation_code => 12
});

ok($either->is_left() eq 1);

$either = $use_case->registry({
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator',
  password => '123456',
  confirmation_code => 12
});

ok($either->is_left() eq 1);

1;
