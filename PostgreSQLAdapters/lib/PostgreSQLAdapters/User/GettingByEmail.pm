package PostgreSQLAdapters::User::GettingByEmail;

use v5.36;
use Data::Monad::Either qw/right left/;
use base 'PostgreSQLAdapters::Factory';
use Core::User::Entity;

sub get(@args) {
  my ($self, $email) = @args;

  my $user = $self->{connection}->db->query('SELECT * FROM users WHERE email = ?', $email)->expand->hash;

  unless ($user) {
    return left('User not found');
  }

  right(Core::User::Entity->new({
    id => $user->{id},
    phone => $user->{phone},
    email => $user->{email},
    role => $user->{role},
    surname => $user->{surname},
    name => $user->{name},
    created => $user->{created},
    updated => $user->{updated}
  }));
}

1;
