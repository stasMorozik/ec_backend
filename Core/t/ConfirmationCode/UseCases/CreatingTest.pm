package ConfirmationCode::UseCases::CreatingTest;

use v5.36;
use Test::More;
use lib 'lib/';

require_ok('Core::ConfirmationCode::Builder');
require_ok('Core::ConfirmationCode::Validators::Code');
require_ok('Core::ConfirmationCode::UseCases::Creating');

package GettingAdapter {
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

package CreatingAdapter {
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

package NotifierAdapter {
  use fields qw();
  use Data::Dump qw(dump);

  sub new(@args) {
    my ($self, $args) = @args;

    $self = fields::new($self);

    $self;
  }

  sub notify(@args) {
    my ($self, $args) = @args;

    dump($args);
  }

  1;
}

my %codes = ();

my $either = Core::ConfirmationCode::Builder->build({
  email => 'georg@gmail.com'
});

$codes{'georg@gmail.com'} = $either->value;

my $getting_adapter = GettingAdapter->new({
  codes => \%codes
});

my $inserting_code_adapter = CreatingAdapter->new({
  codes => \%codes
});

my $notifier_adapter = NotifierAdapter->new();

my $use_case = Core::ConfirmationCode::UseCases::Creating->new({
  getting_code_adapter => $getting_adapter,
  transformer_code_adapter => $inserting_code_adapter,
  notifying_adapter => $notifier_adapter
});

$either = $use_case->create({
  email => 'georg@gmail.com'
});

ok($either->is_left() eq 1);

delete($codes{'georg@gmail.com'});

$either = $use_case->create({
  email => 'georg@gmail.com'
});

ok($either->is_right() eq 1);

$either = $use_case->create({
  email => 'georg@gmail.'
});

ok($either->is_left() eq 1);

1;
