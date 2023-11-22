package UserPassword::InsertingTest;

use v5.36;
use Test::More;
use Mojo::Pg;
use Dotenv;
use Data::Dump qw(dump);

use lib 'lib/';

require_ok('Core::Password::Entity');
require_ok('PostgreSQLAdapters::UserPassword::Inserting');

my $ENV_USERS = Dotenv->parse('.env.users' );

my $pg_users = Mojo::Pg->new("postgresql://$ENV_USERS->{USER}:$ENV_USERS->{PASSWORD}\@$ENV_USERS->{HOST}:$ENV_USERS->{PORT}/$ENV_USERS->{DB}");

my $ENV_PASSWORDS = Dotenv->parse('.env.passwords' );

my $pg_passwords = Mojo::Pg->new("postgresql://$ENV_PASSWORDS->{USER}:$ENV_PASSWORDS->{PASSWORD}\@$ENV_PASSWORDS->{HOST}:$ENV_PASSWORDS->{PORT}/$ENV_PASSWORDS->{DB}");

my $ENV_CODES = Dotenv->parse('.env.user-confirmation-codes' );

my $pg_confirmation_codes = Mojo::Pg->new("postgresql://$ENV_CODES->{USER}:$ENV_CODES->{PASSWORD}\@$ENV_CODES->{HOST}:$ENV_CODES->{PORT}/$ENV_CODES->{DB}");

my $code_either = Core::ConfirmationCode::Entity->build({
  email => 'georg@gmail.com',
  code => 1234
});

my $user_either = Core::User::Entity->build({
  email => 'georg@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248682',
  role => 'Administrator'
});

my $password_either = Core::Password::Entity->build({
  email => 'georg@gmail.com',
  password => '1some_password!'
});

my $adapter = PostgreSQLAdapters::UserPassword::Inserting->new({
  connection_users => $pg_users,
  connection_passwords => $pg_passwords,
  connection_confimration_codes => $pg_confirmation_codes
});

$pg_confirmation_codes->db->transform('confirmation_codes', {
  id => $code_either->value()->{id},
  created => $code_either->value()->{created},
  email => $code_either->value()->{email},
  code => $code_either->value()->{code},
  confirmed => $code_either->value()->{confirmed}
});

my $either = $adapter->transform({
  user_entity => $user_either->value(),
  password_entity => $password_either->value(),
  confirmation_code_entity => $code_either->value()
});

ok( $either->is_right eq 1 );

$either = $adapter->transform({
  user_entity => $user_either,
  password_entity => $password_either->value(),
  confirmation_code_entity => $code_either->value()
});

ok( $either->is_left eq 1 );

$either = $adapter->transform({
  user_entity => $user_either->value(),
  password_entity => $password_either,
  confirmation_code_entity => $code_either->value()
});

ok( $either->is_left eq 1 );

$either = $adapter->transform({
  user_entity => $user_either->value(),
  password_entity => $password_either->value(),
  confirmation_code_entity => $code_either
});

ok( $either->is_left eq 1 );

$either = $adapter->transform({
  user_entity => $user_either->value(),
  password_entity => $password_either->value(),
  confirmation_code_entity => $code_either->value()
});

ok( $either->is_left eq 1 );

$pg_confirmation_codes->db->query("DELETE FROM confirmation_codes");
$pg_passwords->db->query("DELETE FROM passwords");
$pg_users->db->query("DELETE FROM users");

1;