package Api::Admin::Controllers::Registration;

use v5.36;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON;
use Try::Tiny;

use Core::User::Validators::Role;

sub registry($self) {
  my $content_type = $self->req->headers->content_type;
  
  unless ($content_type) {
    return $self->render(json => {message => 'Method not allowed'}, status => 405);
  }

  unless ($content_type eq 'application/json') {
    return $self->render(json => {message => 'Method not allowed'}, status => 405);
  }

  my $registration_admin_use_case = $self->app->{container}->get('registration_admin_use_case');
  my $logger_adapter = $self->app->{container}->get('logger_adapter');

  try {
    my $args = $self->req->json;

    my $either = $registration_admin_use_case->registry({
      email => $args->{email},
      name => $args->{name},
      surname => $args->{surname},
      phone => $args->{phone},
      password => $args->{password},
      confirmation_code => $args->{confirmation_code},
      role => Core::User::Validators::Role::admin()
    });

    if ( $either->is_left() ) {
      $logger_adapter->info({
        message => $either->value
      });

      return $self->render(json => {message => $either->value}, status => 400);
    }

    if ( $either->is_right() ) {
      $logger_adapter->info({
        message => 'Successfully registration admin'
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

