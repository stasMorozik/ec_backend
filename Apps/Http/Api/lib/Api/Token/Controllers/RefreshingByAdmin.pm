package Api::Token::Controllers::RefreshingByAdmin;

use v5.36;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON;
use Try::Tiny;

sub refresh($self) {
  my $refresh_token = $self->session->{refresh_token};
  
  unless ($refresh_token) {
    return $self->render(json => {message => 'Not found refresh token'}, status => 401);
  }

  my $refreshing_by_admin_token_use_case = $self->app->{container}->get('refreshing_by_admin_token_use_case');
  my $logger_adapter = $self->app->{container}->get('logger_adapter');
  
  try {
    my $either = $refreshing_by_admin_token_use_case->refresh({token => $refresh_token});

    if ( $either->is_left() ) {
      $logger_adapter->info({
        message => $either->value
      });

      return $self->render(json => {message => $either->value}, status => 401);
    }

    if ( $either->is_right() ) {
      $logger_adapter->info({
        message => 'Successfully refreshed token'
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
  }
}

1;