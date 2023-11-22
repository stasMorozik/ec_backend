package Api::ConfiramtionCode::Controllers::ConfirmingByAdmin;

use v5.36;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON;
use Try::Tiny;

sub confirm($self) {
  my $content_type = $self->req->headers->content_type;
  
  unless ($content_type) {
    return $self->render(json => {message => 'Method not allowed'}, status => 405);
  }

  unless ($content_type eq 'application/json') {
    return $self->render(json => {message => 'Method not allowed'}, status => 405);
  }

  my $confirming_by_admin_confirmation_code_use_case = $self->app->{container}->get('confirming_by_admin_confirmation_code_use_case');
  my $logger_adapter = $self->app->{container}->get('logger_adapter');

  try {
    my $either = $confirming_by_admin_confirmation_code_use_case->confirm($self->req->json);

    if ( $either->is_left() ) {
      $logger_adapter->info({
        message => $either->value
      });

      return $self->render(json => {message => $either->value}, status => 400);
    }

    if ( $either->is_right() ) {
      $logger_adapter->info({
        message => 'Successfully confirmed code'
      });

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