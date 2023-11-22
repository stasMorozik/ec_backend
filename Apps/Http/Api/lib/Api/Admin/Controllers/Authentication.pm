package Api::Admin::Controllers::Authentication;

use v5.36;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON;
use Try::Tiny;

sub auth($self) {
  my $content_type = $self->req->headers->content_type;
  
  unless ($content_type) {
    return $self->render(json => {message => 'Method not allowed'}, status => 405);
  }

  unless ($content_type eq 'application/json') {
    return $self->render(json => {message => 'Method not allowed'}, status => 405);
  }

  my $authentication_admin_use_case = $self->app->{container}->get('authentication_admin_use_case');
  my $logger_adapter = $self->app->{container}->get('logger_adapter');

  try {
    my $either = $authentication_admin_use_case->auth($self->req->json);

    if ( $either->is_left() ) {
      $logger_adapter->info({
        message => $either->value
      });

      return $self->render(json => {message => $either->value}, status => 400);
    }

    if ( $either->is_right() ) {
      $logger_adapter->info({
        message => 'Successfully authentication admin'
      });

      $self->session->{access_token} = $either->value->{access};
      $self->session->{refresh_token} = $either->value->{refresh};

      return $self->render(json => Mojo::JSON->true, status => 200);
    }
  } catch {
    $logger_adapter->exception({
      message => $_->{message} ? $_->{message} : 'Something went wrong'
    });

    return $self->render(json => {message => 'Something went wrong'}, status => 500);
  };
}

1;