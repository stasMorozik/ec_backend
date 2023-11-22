package PostgreSQLAdapters::Factory;

use v5.36;
use fields qw(connection);

sub new(@args) {
  my ($self, $args) = @args;

  $self = fields::new($self);

  unless ($args->{connection}) {
    die('Invalid connection');
  }

  $self->{connection} = $args->{connection};

  $self;
}

1;