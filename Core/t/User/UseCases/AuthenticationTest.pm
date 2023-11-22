package User::UseCases::AuthenticationTest;

use v5.36;
use Test::More;
use lib 'lib/';
use Data::Monad::Either qw/left right/;

require_ok('Core::User::UseCases::Authentication');
require_ok('Core::Password::Builder');

package GettingPasswordAdapter {
  use fields qw(passwords);
  use Data::Monad::Either qw/left right/;

  sub new(@args) {
    my ($self, $args) = @args;

    $self = fields::new($self);

    $self->{passwords} = $args->{passwords};

    $self;
  }

  sub get(@args) {
    my ($self, $email) = @args;

    my $password = $self->{passwords}->{$email};

    unless ($password) {
      return left('Password not found');
    }

    right($password);
  }

  1;
}

my $access_secret = 'access_secret';
my $refresh_secret = 'refresh_secret';

my %passwords = ();

my $getting_password_adapter = GettingPasswordAdapter->new({
  passwords => \%passwords
});

my $use_case = Core::User::UseCases::Authentication->new({
  getting_password_adapter => $getting_password_adapter,
  access_secret => $access_secret,
  refresh_secret => $refresh_secret
});

my $either = Core::Password::Builder->build({
  email => 'email@gmail.com',
  password => '123456'
});

$passwords{'email@gmail.com'} = $either->value;

$either = $use_case->auth({
  email => 'email@gmail.com',
  password => '123456'
});

ok($either->is_right() eq 1);

$either = $use_case->auth({
  email => 'email@gmail.com',
  password => '12345'
});

ok($either->is_left() eq 1);

$either = $use_case->auth({
  email => 'email1@gmail.com',
  password => '12345'
});

ok($either->is_left() eq 1);

1;





