package PostgreSQLAdapters::ConfirmationCode::Confirming;

use v5.36;
use Data::Monad::Either qw/right left/;
use base 'PostgreSQLAdapters::Factory';

sub transform(@args) {
  my ($self, $code) = @args;
  
  unless ( UNIVERSAL::isa($code, 'Core::ConfirmationCode::Entity') ) {
    return left('Invalid confirmation code for updating');
  }

  my $tx = $self->{connection}->db->begin;

  my $affected_rows = $self->{connection}->db->update('confirmation_codes', {confirmed => 1}, {email => $code->{email} });

  unless ( $affected_rows->rows() ) {
    return left('Confirmation code not found');  
  }

  $tx->commit;

  right(1);
}

1;