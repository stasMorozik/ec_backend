package User::UseCases::AuthorizationTest;

use v5.36;
use Test::More;
use lib 'lib/';
use Data::Monad::Either qw/left right/;

require_ok('Core::User::UseCases::Authorization');
require_ok('Core::User::Builder');
require_ok('Core::Jwt::Builder');

package GettingUserAdapter {
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

my $getting_user_adapter = GettingUserAdapter->new({
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

$either = Core::Jwt::Builder->build({
  access_secret => $access_secret,
  refresh_secret => $refresh_secret,
  email => 'georg@gmail.com'
});

my $token = $either->value;

my $use_case = Core::User::UseCases::Authorization->new({
  getting_user_adapter => $getting_user_adapter,
  access_secret => $access_secret
});

$either = $use_case->auth({
  token => $token->{access}
});

ok($either->is_right() eq 1);

$either = $use_case->auth({
  token => 'Invalid token'
});

ok($either->is_left() eq 1);

1;
