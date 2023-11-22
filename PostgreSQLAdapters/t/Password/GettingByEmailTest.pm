package Password::GettingByEmailTest;

use v5.36;
use Test::More;
use Mojo::Pg;
use Dotenv;

use lib 'lib/';

require_ok('PostgreSQLAdapters::Password::GettingByEmail');

local $ENV = Dotenv->parse('.env.passwords' );

my $pg = Mojo::Pg->new("postgresql://$ENV->{USER}:$ENV->{PASSWORD}\@$ENV->{HOST}:$ENV->{PORT}/$ENV->{DB}");

my $password_either = Core::Password::Entity->build({
  email => 'georg2@gmail.com',
  password => '12345'
});

$pg->db->insert('passwords', {
  id => $password_either->value()->{id},
  password => $password_either->value()->{password},
  created => $password_either->value()->{created},
  email => $password_either->value()->{email}
});

my $adapter = PostgreSQLAdapters::Password::GettingByEmail->new({
  connection => $pg
});

my $either = $adapter->get($password_either->value()->{email});

ok( $either->is_right eq 1 );

$either = $adapter->get('not_found@gmail.com');

ok( $either->is_left eq 1 );

$pg->db->query("DELETE FROM passwords");

1;