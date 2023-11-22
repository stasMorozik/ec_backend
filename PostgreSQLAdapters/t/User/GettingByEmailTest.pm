package User::GettingByEmailTest;

use v5.36;
use Test::More;
use Mojo::Pg;
use Dotenv;

use lib 'lib/';

require_ok('PostgreSQLAdapters::User::GettingByEmail');

local $ENV = Dotenv->parse('.env.users' );

my $pg = Mojo::Pg->new("postgresql://$ENV->{USER}:$ENV->{PASSWORD}\@$ENV->{HOST}:$ENV->{PORT}/$ENV->{DB}");

my $user_either = Core::User::Entity->build({
  email => 'georg1@gmail.com',
  name => 'Georg Hannover',
  surname => 'Ludwig',
  phone => '+79683248680',
  role => 'Administrator'
});

$pg->db->insert('users', {
  id => $user_either->value()->{id},
  name => $user_either->value()->{name},
  surname => $user_either->value()->{surname},
  phone => $user_either->value()->{phone},
  role => $user_either->value()->{role},
  created => $user_either->value()->{created},
  email => $user_either->value()->{email}
});

my $adapter = PostgreSQLAdapters::User::GettingByEmail->new({
  connection => $pg
});

my $either = $adapter->get($user_either->value()->{email});

ok( $either->is_right eq 1 );

$either = $adapter->get('not_found@gmail.com');

ok( $either->is_left eq 1 );

$pg->db->query("DELETE FROM users");

1;
