package ConfirmationCode::InsertingTest;

use v5.36;
use Test::More;
use Mojo::Pg;
use Dotenv;

use lib 'lib/';

require_ok('PostgreSQLAdapters::ConfirmationCode::Inserting');

local $ENV = Dotenv->parse('.env.user-confirmation-codes' );

my $pg = Mojo::Pg->new("postgresql://$ENV->{USER}:$ENV->{PASSWORD}\@$ENV->{HOST}:$ENV->{PORT}/$ENV->{DB}");

my $code_either = Core::ConfirmationCode::Entity->build({
  email => 'georg@gmail.com',
  code => 1234
});

my $adapter = PostgreSQLAdapters::ConfirmationCode::Inserting->new({
  connection => $pg
});

my $either = $adapter->transform($code_either->value());

ok( $either->is_right eq 1 );

$either = $adapter->transform($code_either);

ok( $either->is_left eq 1 );

$either = $adapter->transform('code_either');

ok( $either->is_left eq 1 );

$either = $adapter->transform(0);

ok( $either->is_left eq 1 );

$pg->db->query("DELETE FROM confirmation_codes");

1;