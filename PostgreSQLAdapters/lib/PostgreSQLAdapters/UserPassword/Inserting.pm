package PostgreSQLAdapters::UserPassword::Inserting;

use v5.36;
use Data::Monad::Either qw/right left/;
use fields qw(connection_users connection_passwords connection_confimration_codes);
use Try::Tiny;

use Data::Dump qw(dump);

sub new(@args) {
  my ($self, $args) = @args;

  $self = fields::new($self);

  unless ($args->{connection_users}) {
    die('Invalid connection');
  }

  unless ($args->{connection_passwords}) {
    die('Invalid connection');
  }

  unless ($args->{connection_confimration_codes}) {
    die('Invalid connection');
  }

  $self->{connection_users} = $args->{connection_users};
  $self->{connection_passwords} = $args->{connection_passwords};
  $self->{connection_confimration_codes} = $args->{connection_confimration_codes};

  $self;
}

sub transform(@args) {
  my ($self, $args) = @args;

  unless ( ref($args) eq 'HASH' ) {
    return left('Invalid arguments for inserting user and password');
  }
  
  unless ( UNIVERSAL::isa($args->{user_entity}, 'Core::User::Entity') ) {
    return left('Invalid user for inserting');
  }
  
  unless ( UNIVERSAL::isa($args->{password_entity}, 'Core::Password::Entity') ) {
    return left('Invalid password for inserting');
  }
  
  unless ( UNIVERSAL::isa($args->{confirmation_code_entity}, 'Core::ConfirmationCode::Entity') ) {
    return left('Invalid confirmation code for updating');
  }

  my $either = eval {
    my $tx_users = $self->{connection_users}->db->begin;
    my $tx_passwords = $self->{connection_passwords}->db->begin;
    my $tx_confimration_codes = $self->{connection_confimration_codes}->db->begin;

    my $confirmation_codes_rows = $self->{connection_confimration_codes}->db->query(
      'DELETE FROM confirmation_codes WHERE email = ?', 
      $args->{confirmation_code_entity}->{email}
    );

    my $users_rows = $self->{connection_users}->db->insert('users', {
      id => $args->{user_entity}->{id},
      name => $args->{user_entity}->{name},
      surname => $args->{user_entity}->{surname},
      phone => $args->{user_entity}->{phone},
      role => $args->{user_entity}->{role},
      created => $args->{user_entity}->{created},
      updated => $args->{user_entity}->{updated},
      email => $args->{user_entity}->{email}
    }, {returning => 'id'});

    my $passwords_rows = $self->{connection_passwords}->db->insert('passwords', {
      id => $args->{password_entity}->{id},
      created => $args->{password_entity}->{created},
      updated => $args->{password_entity}->{updated},
      email => $args->{password_entity}->{email},
      password => $args->{password_entity}->{password}
    }, {returning => 'id'});

    unless ( $passwords_rows->hash->{id} ) {
      return left('Password already exists');
    }
    
    unless ( $users_rows->hash->{id} ) {
      return left('User already exists');
    }

    $tx_users->commit();
    $tx_passwords->commit();
    $tx_confimration_codes->commit();

    right(1);
  };

  unless ($@) {
    return $either;
  }
  
  if ($@) {
    die $@;
  }
}

1;
