use v5.36;
use Test::More;
use lib::relative './';

use User::GettingByEmailTest;
use Password::GettingByEmailTest;
use ConfirmationCode::GettingByEmailTest;
use ConfirmationCode::InsertingTest;
use ConfirmationCode::ConfirmingTest;
use UserPassword::InsertingTest;

done_testing(27);
