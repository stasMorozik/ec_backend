package Product::UseCases::CreatingTest;

use v5.36;
use Test::More;
use lib 'lib/';
use Data::Dump qw(dump);

require_ok('Core::Product::Entity');
require_ok('Core::Product::UseCases::Creating');

require_ok('Core::User::UseCases::Authorization');
require_ok('Core::User::Builder');
require_ok('Core::Jwt::Builder');

# package GettingAdminAdapter {
#   use fields qw(users);
#   use Data::Monad::Either qw/left right/;

#   sub new(@args) {
#     my ($self, $args) = @args;

#     $self = fields::new($self);

#     $self->{users} = $args->{users};

#     $self;
#   }

#   sub get(@args) {
#     my ($self, $email) = @args;

#     my $user = $self->{users}->{$email};

#     unless ($user) {
#       return left('User not found');
#     }

#     right($user);
#   }

#   1;
# }

# package InsertingProuctAdapter {
#   use fields qw(products event_emiter);
#   use Data::Monad::Either qw/left right/;
  
#   sub new(@args) {
#     my ($self, $args) = @args;

#     $self = fields::new($self);

#     $self->{products} = $args->{products};
#     $self->{event_emiter} = $args->{event_emiter};

#     $self;
#   }

#   sub transform(@args) {
#     my ($self, $product) = @args;
    
#     $self->{products}->{ $product->{id} } = $product;

#     right(1);
#   }

#   1;
# }

# package PuttingFilesAdapter {
#   use fields qw(logos images event_emiter);
#   use Data::Monad::Either qw/left right/;

#   sub new(@args) {
#     my ($self, $args) = @args;

#     $self = fields::new($self);

#     $self->{logos} = $args->{logos};
#     $self->{images} = $args->{images};

#     $self;
#   }

#   sub put(@args) {
#     my ($self, $product) = @args;

#     $self->{logos}->{ $product->{id} } = $product->{logo};
#     $self->{images}->{ $product->{id} } = $product->{images};

#     right(1);
#   }

#   1;
# }

# my $access_secret = 'access_secret';
# my $refresh_secret = 'refresh_secret';

# my %users = ();

# my $getting_user_adapter = GettingAdminAdapter->new({
#   users => \%users
# });

# my $either = Core::User::Builder->build({
#   email => 'georg@gmail.com',
#   name => 'Georg Hannover',
#   surname => 'Ludwig',
#   phone => '+79683248682',
#   role => 'Administrator'
# });

# $users{'georg@gmail.com'} = $either->value;

# $either = Core::Jwt::Builder->build({
#   access_secret => $access_secret,
#   refresh_secret => $refresh_secret,
#   email => 'georg@gmail.com'
# });

# my $token = $either->value;

# my $authorization_use_case = Core::User::UseCases::Authorization->new({
#   getting_user_adapter => $getting_user_adapter,
#   access_secret => $access_secret
# });

# my %products = ();
# my %images = ();
# my %logos = ();

# my $inserting_entity_adapter = InsertingProuctAdapter->new({
#   products => \%products
# });

# my $putting_files_adapter = PuttingFilesAdapter->new({
#   logos => \%logos,
#   images => \%images
# });

# my $creating_product_use_case = Core::Product::UseCases::Creating->new({
#   authorization_use_case => $authorization_use_case,
#   transformer_adapter => $inserting_entity_adapter,
#   putting_files_adapter => $putting_files_adapter,
#   web_dav_uri => "https://web-dav.com"
# });

# $either = $creating_product_use_case->create({
#   token => $token->{access},
#   title => 'Some title',
#   description => 'Some description',
#   price => 10.5,
#   amount => 120,
#   brand => {
#     id => 1,
#     name => 'Some Brand'
#   },
#   catalog => {
#     id => 1,
#     name => 'Some Catalog'
#   },
#   article => '123345',
#   features => [
#     {
#       title => 'Some Title',
#       features => [
#         {
#           title => 'Some Title',
#           text => 'Some Fature Text'
#         }
#       ]
#     }
#   ],
#   image_path => '/var/www/data',
#   logo => {
#     filename => 'test.png',
#     size => 135,
#     binary => '
#       <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
#         <circle cx="50" cy="50" r="40" />
#         <circle cx="150" cy="50" r="4" />
#         <svg viewBox="0 0 10 10" x="200" width="100">
#           <circle cx="5" cy="5" r="4" />
#         </svg>
#       </svg>
#     '
#   },
#   images => [
#     {
#       filename => 'test.png',
#       size => 135,
#       binary => '
#         <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
#           <circle cx="50" cy="50" r="40" />
#           <circle cx="150" cy="50" r="4" />
#           <svg viewBox="0 0 10 10" x="200" width="100">
#             <circle cx="5" cy="5" r="4" />
#           </svg>
#         </svg>
#       ',
#     }
#   ]
# });

# ok($either->is_right() eq 1);

# $either = $creating_product_use_case->create({
#   title => 'Some title',
#   description => 'Some description',
#   price => 10.5,
#   amount => 120,
#   brand => {
#     id => 1,
#     name => 'Some Brand'
#   },
#   catalog => {
#     id => 1,
#     name => 'Some Catalog'
#   },
#   article => '123345',
#   features => [
#     {
#       title => 'Some Title',
#       features => [
#         {
#           title => 'Some Title',
#           text => 'Some Fature Text'
#         }
#       ]
#     }
#   ],
#   image_path => '/var/www/data',
#   logo => {
#     filename => 'test.png',
#     size => 135,
#     binary => '
#       <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
#         <circle cx="50" cy="50" r="40" />
#         <circle cx="150" cy="50" r="4" />
#         <svg viewBox="0 0 10 10" x="200" width="100">
#           <circle cx="5" cy="5" r="4" />
#         </svg>
#       </svg>
#     '
#   },
#   images => [
#     {
#       filename => 'test.png',
#       size => 135,
#       binary => '
#         <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
#           <circle cx="50" cy="50" r="40" />
#           <circle cx="150" cy="50" r="4" />
#           <svg viewBox="0 0 10 10" x="200" width="100">
#             <circle cx="5" cy="5" r="4" />
#           </svg>
#         </svg>
#       ',
#     }
#   ]
# });

# ok($either->is_left() eq 1);

# $either = $creating_product_use_case->create({
#   token => 'invalid token',
#   title => 'Some title',
#   description => 'Some description',
#   price => 10.5,
#   amount => 120,
#   brand => {
#     id => 1,
#     name => 'Some Brand'
#   },
#   catalog => {
#     id => 1,
#     name => 'Some Catalog'
#   },
#   article => '123345',
#   features => [
#     {
#       title => 'Some Title',
#       features => [
#         {
#           title => 'Some Title',
#           text => 'Some Fature Text'
#         }
#       ]
#     }
#   ],
#   image_path => '/var/www/data',
#   logo => {
#     filename => 'test.png',
#     size => 135,
#     binary => '
#       <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
#         <circle cx="50" cy="50" r="40" />
#         <circle cx="150" cy="50" r="4" />
#         <svg viewBox="0 0 10 10" x="200" width="100">
#           <circle cx="5" cy="5" r="4" />
#         </svg>
#       </svg>
#     '
#   },
#   images => [
#     {
#       filename => 'test.png',
#       size => 135,
#       binary => '
#         <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
#           <circle cx="50" cy="50" r="40" />
#           <circle cx="150" cy="50" r="4" />
#           <svg viewBox="0 0 10 10" x="200" width="100">
#             <circle cx="5" cy="5" r="4" />
#           </svg>
#         </svg>
#       ',
#     }
#   ]
# });

# ok($either->is_left() eq 1);

1;