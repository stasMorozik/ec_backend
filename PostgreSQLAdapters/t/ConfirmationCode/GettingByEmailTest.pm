package ConfirmationCode::GettingByEmailTest;

use v5.36;
use Test::More;
use Mojo::Pg;
use Dotenv;

use lib 'lib/';

require_ok('PostgreSQLAdapters::ConfirmationCode::GettingByEmail');

local $ENV = Dotenv->parse('.env.user-confirmation-codes' );

my $pg = Mojo::Pg->new("postgresql://$ENV->{USER}:$ENV->{PASSWORD}\@$ENV->{HOST}:$ENV->{PORT}/$ENV->{DB}");

my $code_either = Core::ConfirmationCode::Entity->build({
  email => 'georg3@gmail.com',
  code => 1234
});

my $adapter = PostgreSQLAdapters::ConfirmationCode::GettingByEmail->new({
  connection => $pg
});

$pg->db->insert('confirmation_codes', {
  id => $code_either->value()->{id},
  created => $code_either->value()->{created},
  email => $code_either->value()->{email},
  code => $code_either->value()->{code},
  confirmed => $code_either->value()->{confirmed}
});

my $either = $adapter->get($code_either->value()->{email});

ok( $either->is_right eq 1 );

$either = $adapter->get('not_found@gmail.com');

ok( $either->is_left eq 1 );

$pg->db->query("DELETE FROM confirmation_codes");

1;
