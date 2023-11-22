package Api::User::Controllers::Authorization;

use v5.36;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON;
use Try::Tiny;

sub auth($self) {
  my $access_token = $self->session->{access_token};

  unless ($access_token) {
    return $self->render(json => {message => 'Not found access token'}, status => 401);
  }

  my $authorization_user_use_case = $self->app->{container}->get('authorization_user_use_case');
  my $logger_adapter = $self->app->{container}->get('logger_adapter');

  try {
    my $either = $authorization_user_use_case->auth({token => $access_token});

    if ( $either->is_left() ) {
      $logger_adapter->info({
        message => $either->value
      });

      return $self->render(json => {message => $either->value}, status => 401);
    }

    if ( $either->is_right() ) {
      $logger_adapter->info({
        message => 'Successfully authorization user'
      });

      return $self->render(json => {
        email => $either->value->{email},
        name => $either->value->{name},
        surname => $either->value->{surname},
        phone => $either->value->{phone},
        role => $either->value->{role},
        created => $either->value->{created}
      }, status => 200);
    }
  } catch {
    $logger_adapter->exception({
      message => $_->{message} ? $_->{message} : 'Something went wrong'
    });

    return $self->render(json => {message => 'Something went wrong'}, status => 500);
  };
}

1;