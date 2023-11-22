use v5.36;

use Mojolicious::Lite;
use Mojo::JSON qw(decode_json);

use lib 'lib/';

use Api::DependencyInjection;

post('/api/v1/user/confirmation-code/')->to('CreatingByUser#create', namespace => 'Api::ConfiramtionCode::Controllers');
patch('/api/v1/user/confirmation-code/')->to('ConfirmingByUser#confirm', namespace => 'Api::ConfiramtionCode::Controllers');

post('/api/v1/admin/confirmation-code/')->to('CreatingByAdmin#create', namespace => 'Api::ConfiramtionCode::Controllers');
patch('/api/v1/admin/confirmation-code/')->to('ConfirmingByAdmin#confirm', namespace => 'Api::ConfiramtionCode::Controllers');

post('/api/v1/user/')->to('Registration#registry', namespace => 'Api::User::Controllers');
post('/api/v1/user/authentication/')->to('Authentication#auth', namespace => 'Api::User::Controllers');
get('/api/v1/user/authorization/')->to('Authorization#auth', namespace => 'Api::User::Controllers');
get('/api/v1/user/token/refresh/')->to('RefreshingByUser#refresh', namespace => 'Api::Token::Controllers');

post('/api/v1/admin/')->to('Registration#registry', namespace => 'Api::Admin::Controllers');
post('/api/v1/admin/authentication/')->to('Authentication#auth', namespace => 'Api::Admin::Controllers');
get('/api/v1/admin/authorization/')->to('Authorization#auth', namespace => 'Api::Admin::Controllers');
get('/api/v1/admin/token/refresh/')->to('RefreshingByAdmin#refresh', namespace => 'Api::Token::Controllers');

any '*' => sub ($c) {
  $c->render(json => {message => 'Method not found'}, status => 404);
};

app->hook(before_server_start => sub ($server, $app) {
  $app->{container} = $Api::DependencyInjection::container;
});

app->start;