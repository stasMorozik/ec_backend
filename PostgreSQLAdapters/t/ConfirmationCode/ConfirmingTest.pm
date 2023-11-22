package ConfirmationCode::ConfirmingTest;

use v5.36;
use Test::More;
use Mojo::Pg;
use Dotenv;

use lib 'lib/';

require_ok('PostgreSQLAdapters::ConfirmationCode::Confirming');

local $ENV = Dotenv->parse('.env.user-confirmation-codes' );

my $pg = Mojo::Pg->new("postgresql://$ENV->{USER}:$ENV->{PASSWORD}\@$ENV->{HOST}:$ENV->{PORT}/$ENV->{DB}");

my $code_either = Core::ConfirmationCode::Entity->build({
  email => 'georg@gmail.com',
  code => 1234
});

my $adapter = PostgreSQLAdapters::ConfirmationCode::Confirming->new({
  connection => $pg
});

$pg->db->insert('confirmation_codes', {
  id => $code_either->value()->{id},
  created => $code_either->value()->{created},
  email => $code_either->value()->{email},
  code => $code_either->value()->{code},
  confirmed => $code_either->value()->{confirmed}
});

my $either = $adapter->transform($code_either->value());

ok( $either->is_right eq 1 );

$either = $adapter->transform('some_string');

ok( $either->is_left eq 1 );

$either = $adapter->transform(0);

ok( $either->is_left eq 1 );

$either = $adapter->transform($code_either);

ok( $either->is_left eq 1 );

$pg->db->query("DELETE FROM transformation_codes");

$either = $adapter->transform($code_either->value());

ok( $either->is_left eq 1 );

1;