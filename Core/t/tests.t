use v5.36;
use Test::More;
use lib::relative './';

use User::EntityTest;
use Password::EntityTest;
use Product::EntityTest;
use ConfirmationCode::EntityTest;
use User::UseCases::RegistrationTest;
use Jwt::EntityTest;
use User::UseCases::AuthenticationTest;
use User::UseCases::AuthorizationTest;
use ConfirmationCode::UseCases::CreatingTest;
use ConfirmationCode::UseCases::ConfirmingTest;
use ConfirmationCode::UseCases::CreatingByAdminTest;
use Product::UseCases::CreatingTest;

done_testing(101);
