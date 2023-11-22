package PostgreSQLAdapters::Password::GettingByEmail;

use v5.36;
use Data::Monad::Either qw/right left/;
use Core::Password::Entity;
use base 'PostgreSQLAdapters::Factory';

sub get(@args) {
  my ($self, $email) = @args;

  my $password = $self->{connection}->db->query('SELECT * FROM passwords WHERE email = ?', $email)->expand->hash;

  unless ($password) {
    return left('Email not found');
  }

  right(Core::Password::Entity->new({
    id => $password->{id},
    email => $password->{email},
    password => $password->{password},
    created => $password->{created},
    updated => $password->{updated}
  }));
}

1;
