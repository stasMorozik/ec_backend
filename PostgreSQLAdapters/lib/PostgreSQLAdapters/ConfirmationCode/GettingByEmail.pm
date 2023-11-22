package PostgreSQLAdapters::ConfirmationCode::GettingByEmail;

use v5.36;
use Data::Monad::Either qw/right left/;
use Core::ConfirmationCode::Entity;
use base 'PostgreSQLAdapters::Factory';

sub get(@args) {
  my ($self, $email) = @args;

  my $code = $self->{connection}->db->query('SELECT * FROM confirmation_codes WHERE email = ?', $email)->expand->hash;

  unless ($code) {
    return left('Confirmation code not found');
  }

  right(Core::ConfirmationCode::Entity->new({
    id => $code->{id},
    email => $code->{email},
    code => $code->{code},
    created => $code->{created},
    confirmed => $code->{confirmed}
  }));
}

1;
