package ConfirmationCode::UseCases::ConfirmingTest;

use v5.36;
use Test::More;
use lib 'lib/';
use Data::Dump qw(dump);

require_ok('Core::ConfirmationCode::Builder');
require_ok('Core::ConfirmationCode::Validators::Code');
require_ok('Core::ConfirmationCode::UseCases::Confirming');

package GettingCodeAdapter {
  use fields qw(codes);
  use Data::Monad::Either qw/left right/;

  sub new(@args) {
    my ($self, $args) = @args;

    $self = fields::new($self);

    $self->{codes} = $args->{codes};

    $self;
  }

  sub get(@args) {
    my ($self, $email) = @args;

    my $code = $self->{codes}->{$email};

    unless ($code) {
      return left('Code not found');
    }

    right($code);
  }

  1;
}

package ConfirmingAdapter {
  use fields qw(codes);
  use Data::Monad::Either qw/left right/;

  sub new(@args) {
    my ($self, $args) = @args;

    $self = fields::new($self);

    $self->{codes} = $args->{codes};

    $self;
  }

  sub transform(@args) {
    my ($self, $entity) = @args;

    $self->{codes}->{
      $entity->{email}
    } = $entity;

    right(1);
  }

  1;
}

my %codes = ();

my $either = Core::ConfirmationCode::Builder->build({
  email => 'georg@gmail.com',
  code => int(rand(
    Core::ConfirmationCode::Validators::Code->upper_limit() - Core::ConfirmationCode::Validators::Code->lower_limit()
  )) + Core::ConfirmationCode::Validators::Code->lower_limit()
});

$codes{'georg@gmail.com'} = $either->value;

my $getting_adapter = GettingCodeAdapter->new({
  codes => \%codes
});

my $confirming_adapter = ConfirmingAdapter->new({
  codes => \%codes
});

my $use_case = Core::ConfirmationCode::UseCases::Confirming->new({
  getting_code_adapter => $getting_adapter,
  transformer_code_adapter => $confirming_adapter
});

$either = $use_case->confirm({
  email => 'georg@gmail.com',
  code => $codes{'georg@gmail.com'}->{code}
});

ok($either->is_right() eq 1);

$either = $use_case->confirm({
  email => 'georg@gmail.com',
  code => 12
});

ok($either->is_left() eq 1);

$either = $use_case->confirm({
  email => 'georg1@gmail.com',
  code => $codes{'georg@gmail.com'}->{code}
});

ok($either->is_left() eq 1);

1;
