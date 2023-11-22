package AMQPAdapters::Adapters::Logger;

use v5.36;
use fields qw(publisher channel queue);
use POSIX qw(strftime);
use Mojo::JSON qw(encode_json);

use Data::Dump qw(dump);

sub new(@args) {
  my ($self, $args) = @args;

  $self = fields::new($self);

  unless ($args->{channel}) {
    die('Invalid channel');
  }

  unless ($args->{queue}) {
    die('Invalid queue');
  }

  unless ( UNIVERSAL::can($args->{publisher}, "publish") ) {
    die('Invalid publisher');
  }

  $self->{channel} = $args->{channel};
  $self->{queue} = $args->{queue};
  $self->{publisher} = $args->{publisher};

  $self;
}

my $log = sub (@args) {
  my ($self, $args) = @args;

  $args->{date} = strftime '%Y-%m-%d %X', localtime;

  $self->{publisher}->publish($self->{channel}, $self->{queue}, encode_json($args) );
};

sub exception(@args) {
  my ($self, $args) = @args;

  $args->{type} = 'exception';

  &$log($self, $args);
}

sub warning(@args) {
  my ($self, $args) = @args;

  $args->{type} = 'warning';

  &$log($self, $args);
}

sub info(@args) {
  my ($self, $args) = @args;

  $args->{type} = 'info';

  &$log($self, $args);
}

sub debug(@args) {
  my ($self, $args) = @args;

  $args->{type} = 'debug';

  &$log($self, $args);
}

sub telemetry(@args) {
  my ($self, $args) = @args;

  $args->{type} = 'telemetry';

  &$log($self, $args);
}

1;