package Core::Password::Methods::Verification;

use v5.36;
use Data::Monad::Either qw/right left/;
use Crypt::PBKDF2;

sub verify($self, $args) {
  unless ( UNIVERSAL::isa($args->{entity}, 'Core::Password::Entity') ) {
    return left('Invalid password for verification');
  }

  unless ($args->{password}) {
    return left('Invalid password');
  }

  my $hasher = Crypt::PBKDF2->new(
    hash_class => 'HMACSHA2',
    hash_args => {
      sha_size => 512,
    },
    iterations => 10000,
    salt_len => 10,
  );

  my $resul_valid = $hasher->validate($args->{entity}->{password}, $args->{password});

  $hasher = 0;

  unless ( $resul_valid ) {
    return left('Wrong password');
  }

  right(1);
}

1;