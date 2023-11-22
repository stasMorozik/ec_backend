package PostgreSQLAdapters::ConfirmationCode::Inserting;

use v5.36;
use Data::Monad::Either qw/right left/;
use base 'PostgreSQLAdapters::Factory';

sub transform(@args) {
  my ($self, $code) = @args;
  
  unless ( UNIVERSAL::isa($code, 'Core::ConfirmationCode::Entity') ) {
    return left('Invalid confirmation code for inserting');
  }

  my $tx = $self->{connection}->db->begin;

  $self->{connection}->db->query('DELETE FROM confirmation_codes WHERE email = ?', $code->{email});
  
  $self->{connection}->db->insert('confirmation_codes', {
    id => $code->{id},
    created => $code->{created},
    email => $code->{email},
    code => $code->{code},
    confirmed => $code->{confirmed}
  });

  $tx->commit;

  right(1);
}

1;