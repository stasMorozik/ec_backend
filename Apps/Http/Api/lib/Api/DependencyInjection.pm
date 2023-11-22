package Api::DependencyInjection;

use v5.36;

use Beam::Wire;
use Mojo::Pg;
use Dotenv;
use Net::AMQP::RabbitMQ;

use Core::ConfirmationCode::UseCases::Creating;
use Core::ConfirmationCode::UseCases::CreatingByAdmin;
use Core::ConfirmationCode::UseCases::Confirming;
use Core::User::UseCases::Registration;;
use Core::User::UseCases::Authentication;
use Core::User::UseCases::Authorization;
use Core::Jwt::UseCases::Refreshing;

use PostgreSQLAdapters::ConfirmationCode::Inserting;
use PostgreSQLAdapters::ConfirmationCode::Confirming;
use PostgreSQLAdapters::ConfirmationCode::GettingByEmail;
use PostgreSQLAdapters::UserPassword::Inserting;
use PostgreSQLAdapters::Password::GettingByEmail;
use PostgreSQLAdapters::User::GettingByEmail;

use AMQPAdapters::Adapters::Mailer;
use AMQPAdapters::Adapters::Logger;

our $container = Beam::Wire->new(config => {});

$container->set(
  'params_connection_db_user_confirmation_codes' => Dotenv->parse('./env/.env.db.user-confirmation-codes')
);

$container->set(
  'params_connection_db_admin_confirmation_codes' => Dotenv->parse('./env/.env.db.admin-confirmation-codes')
);

$container->set(
  'params_connection_db_passwords' => Dotenv->parse('./env/.env.db.passwords')
);

$container->set(
  'params_connection_db_users' => Dotenv->parse('./env/.env.db.users')
);

$container->set(
  'params_connection_publisher' => Dotenv->parse('./env/.env.amqp')
);

$container->set(
  'user_access_token_secret_key' => &{ sub {
    my $env = Dotenv->parse('./env/.env.user-token-secret-keys');
    return $env->{ACCESS}
  }}()
);

$container->set(
  'user_refresh_token_secret_key' => &{ sub {
    my $env = Dotenv->parse('./env/.env.user-token-secret-keys');
    return $env->{REFRESH}
  }}()
);

$container->set(
  'admin_access_token_secret_key' => &{ sub {
    my $env = Dotenv->parse('./env/.env.admin-token-secret-keys');
    return $env->{ACCESS}
  }}()
);

$container->set(
  'admin_refresh_token_secret_key' => &{ sub {
    my $env = Dotenv->parse('./env/.env.admin-token-secret-keys');
    return $env->{REFRESH}
  }}()
);

$container->set(
  'connection_db_user_confirmation_code' => &{ sub { 
    my $params = $container->get('params_connection_db_user_confirmation_codes');
    return Mojo::Pg->new("postgresql://$params->{USER}:$params->{PASSWORD}\@$params->{HOST}:$params->{PORT}/$params->{DB}");
  }}()
);

$container->set(
  'connection_db_admin_confirmation_code' => &{ sub { 
    my $params = $container->get('params_connection_db_admin_confirmation_codes');
    return Mojo::Pg->new("postgresql://$params->{USER}:$params->{PASSWORD}\@$params->{HOST}:$params->{PORT}/$params->{DB}");
  }}()
);

$container->set(
  'connection_db_users' => &{ sub { 
    my $params = $container->get('params_connection_db_users');
    return Mojo::Pg->new("postgresql://$params->{USER}:$params->{PASSWORD}\@$params->{HOST}:$params->{PORT}/$params->{DB}");
  }}()
);

$container->set(
  'connection_db_passwords' => &{ sub { 
    my $params = $container->get('params_connection_db_passwords');
    return Mojo::Pg->new("postgresql://$params->{USER}:$params->{PASSWORD}\@$params->{HOST}:$params->{PORT}/$params->{DB}");
  }}()
);

$container->set(
  'channel_mailer' => 1
);

$container->set(
  'channel_logger' => 2
);

$container->set(
  'queue_mailer' => 'mailer'
);

$container->set(
  'queue_logger' => 'logger'
);

$container->set(
  'publisher' => &{ sub { 
    my $params = $container->get('params_connection_publisher');
    
    my $channel_mailer = $container->get('channel_mailer');
    my $channel_logger = $container->get('channel_logger');

    my $queue_mailer = $container->get('queue_mailer');
    my $queue_logger = $container->get('queue_logger');

    my $publiser = Net::AMQP::RabbitMQ->new();

    $publiser->connect($params->{HOST}, { user => $params->{USER}, password => $params->{PASSWORD} });

    $publiser->channel_open($channel_mailer);
    $publiser->channel_open($channel_logger);

    $publiser->queue_declare($channel_mailer, $queue_mailer);
    $publiser->queue_declare($channel_logger, $queue_logger);

    return $publiser;
  }}()
);

$container->set(
  'notifying_adapter' => &{ sub { 
    return AMQPAdapters::Notifying::Mailer->new({
      publisher => $container->get('publisher'),
      channel => $container->get('channel_mailer'),
      queue => $container->get('queue_mailer')
    });
  }}()
);

$container->set(
  'logger_adapter' => &{ sub { 
    return AMQPAdapters::Notifying::Logger->new({
      publisher => $container->get('publisher'),
      channel => $container->get('channel_logger'),
      queue => $container->get('queue_logger')
    });
  }}()
);

$container->set(
  'inserting_admin_confirmation_code_adapter' => &{ sub {
    return PostgreSQLAdapters::ConfirmationCode::Inserting->new({
      connection => $container->get('connection_db_admin_confirmation_code')
    });
  }}()
);

$container->set(
  'getting_admin_confirmation_code_adapter' => &{ sub {
    return PostgreSQLAdapters::ConfirmationCode::GettingByEmail->new({
      connection => $container->get('connection_db_admin_confirmation_code')
    });
  }}()
);

$container->set(
  'confirming_admin_confirmation_code_adapter' => &{ sub {
    return PostgreSQLAdapters::ConfirmationCode::Confirming->new({
      connection => $container->get('connection_db_admin_confirmation_code')
    });
  }}()
);

$container->set(
  'inserting_user_confirmation_code_adapter' => &{ sub {
    return PostgreSQLAdapters::ConfirmationCode::Inserting->new({
      connection => $container->get('connection_db_user_confirmation_code')
    });
  }}()
);

$container->set(
  'getting_user_confirmation_code_adapter' => &{ sub {
    return PostgreSQLAdapters::ConfirmationCode::GettingByEmail->new({
      connection => $container->get('connection_db_user_confirmation_code')
    });
  }}()
);

$container->set(
  'confirming_user_confirmation_code_adapter' => &{ sub {
    return PostgreSQLAdapters::ConfirmationCode::Confirming->new({
      connection => $container->get('connection_db_user_confirmation_code')
    });
  }}()
);

$container->set(
  'getting_password_adapter' => &{ sub {
    return PostgreSQLAdapters::Password::GettingByEmail->new({
      connection => $container->get('connection_db_passwords')
    });
  }}()
);

$container->set(
  'getting_user_adapter' => &{ sub {
    return PostgreSQLAdapters::User::GettingByEmail->new({
      connection => $container->get('connection_db_users')
    });
  }}()
);

$container->set(
  'creaing_user_password_adapter' => &{ sub {
    return PostgreSQLAdapters::UserPassword::Inserting->new({
      connection_confimration_codes => $container->get('connection_db_user_confirmation_code'),
      connection_passwords => $container->get('connection_db_passwords'),
      connection_users => $container->get('connection_db_users'),
    });
  }}()
);

$container->set(
  'creaing_admin_password_adapter' => &{ sub {
    return PostgreSQLAdapters::UserPassword::Inserting->new({
      connection_confimration_codes => $container->get('connection_db_admin_confirmation_code'),
      connection_passwords => $container->get('connection_db_passwords'),
      connection_users => $container->get('connection_db_users'),
    });
  }}()
);

$container->set(
  'creating_by_user_confirmation_code_use_case' => &{ sub {
    return Core::ConfirmationCode::UseCases::Creating->new({
      getting_code_adapter => $container->get('getting_user_confirmation_code_adapter'),
      creating_code_adapter => $container->get('inserting_user_confirmation_code_adapter'),
      notifying_adapter => $container->get('notifying_adapter')
    });
  }}()
);

$container->set(
  'confirming_by_user_confirmation_code_use_case' => &{ sub {
    return Core::ConfirmationCode::UseCases::Confirming->new({
      getting_code_adapter => $container->get('getting_user_confirmation_code_adapter'),
      confirming_code_adapter => $container->get('confirming_user_confirmation_code_adapter'),
    });
  }}()
);

$container->set(
  'registration_user_use_case' => &{ sub {
    return Core::User::UseCases::Registration->new({
      creating_adapter => $container->get('creaing_user_password_adapter'),
      getting_code_adapter => $container->get('getting_user_confirmation_code_adapter'),
      notifying_adapter => $container->get('notifying_adapter'),
    });
  }}()
);

$container->set(
  'authentication_user_use_case' => &{ sub {
    return Core::User::UseCases::Authentication->new({
      getting_password_adapter => $container->get('getting_password_adapter'),
      access_secret => $container->get('user_access_token_secret_key'),
      refresh_secret => $container->get('user_refresh_token_secret_key'),
    });
  }}()
);

$container->set(
  'authorization_user_use_case' => &{ sub {
    return Core::User::UseCases::Authorization->new({
      getting_user_adapter => $container->get('getting_user_adapter'),
      access_secret => $container->get('user_access_token_secret_key')
    });
  }}()
);

$container->set(
  'refreshing_by_user_token_use_case' => &{ sub {
    return Core::Jwt::UseCases::Refreshing->new({
      access_secret => $container->get('user_access_token_secret_key'),
      refresh_secret => $container->get('user_refresh_token_secret_key')
    });
  }}()
);

$container->set(
  'confirming_by_admin_confirmation_code_use_case' => &{ sub {
    return Core::ConfirmationCode::UseCases::Confirming->new({
      getting_code_adapter => $container->get('getting_admin_confirmation_code_adapter'),
      confirming_code_adapter => $container->get('confirming_admin_confirmation_code_adapter'),
    });
  }}()
);

$container->set(
  'registration_admin_use_case' => &{ sub {
    return Core::User::UseCases::Registration->new({
      creating_adapter => $container->get('creaing_admin_password_adapter'),
      getting_code_adapter => $container->get('getting_admin_confirmation_code_adapter'),
      notifying_adapter => $container->get('notifying_adapter'),
    });
  }}()
);

$container->set(
  'authentication_admin_use_case' => &{ sub {
    return Core::User::UseCases::Authentication->new({
      getting_password_adapter => $container->get('getting_password_adapter'),
      access_secret => $container->get('admin_access_token_secret_key'),
      refresh_secret => $container->get('admin_refresh_token_secret_key'),
    });
  }}()
);

$container->set(
  'authorization_admin_use_case' => &{ sub {
    return Core::User::UseCases::Authorization->new({
      getting_user_adapter => $container->get('getting_user_adapter'),
      access_secret => $container->get('admin_access_token_secret_key')
    });
  }}()
);

$container->set(
  'creating_by_admin_confirmation_code_use_case' => &{ sub {
    return Core::ConfirmationCode::UseCases::CreatingByAdmin->new({
      authorization_use_case => $container->get('authorization_admin_use_case'),
      getting_code_adapter => $container->get('getting_admin_confirmation_code_adapter'),
      creating_code_adapter => $container->get('inserting_admin_confirmation_code_adapter'),
      notifying_adapter => $container->get('notifying_adapter')
    });
  }}()
);

$container->set(
  'refreshing_by_admin_token_use_case' => &{ sub {
    return Core::Jwt::UseCases::Refreshing->new({
      access_secret => $container->get('admin_access_token_secret_key'),
      refresh_secret => $container->get('admin_refresh_token_secret_key')
    });
  }}()
);

1;