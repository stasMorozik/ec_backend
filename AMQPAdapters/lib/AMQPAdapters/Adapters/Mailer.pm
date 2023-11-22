package AMQPAdapters::Adapters::Mailer;

use v5.36;
use fields qw(publisher channel queue);
use Data::Monad::Either qw/right left/;
use Mojo::JSON qw(encode_json);

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

sub notify(@args) {
  my ($self, $args) = @args;

  unless ($args->{email}) {
    return left('Invalid email to send email');
  }

  unless ($args->{subject}) {
    return left('Invalid subject to send email');
  }

  unless ($args->{message}) {
    return left('Invalid message to send email');
  }

  $self->{publisher}->publish($self->{channel}, $self->{queue}, encode_json($args) );

  right(1);
}

1;