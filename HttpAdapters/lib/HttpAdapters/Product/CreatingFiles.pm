package HttpAdapters::Product::CreatingFiles;

use v5.36;
use fields qw(user_agent user_web_dav password_web_dav);
use Data::Monad::Either qw/right left/;
use Mojo::UserAgent;

sub new(@args) {
  my ($self, $args) = @args;

  $self = fields::new($self);

  unless ($args->{user_web_dav}) {
    die('Invalid user web dav');
  }

  unless ($args->{password_web_dav}) {
    die('Invalid password web dav');
  }

  $self->{user_agent} = Mojo::UserAgent->new;
  $self->{user_web_dav} = $args->{user_web_dav};
  $self->{password_web_dav} = $args->{password_web_dav};

  $self;
}

sub create(@args) {
  my ($self, $product) = @args;

  unless ( UNIVERSAL::isa($product, 'Core::Product::Entity') ) {
    $self->{event_emiter}->emit(result_creating_files => left('Invalid product'));
  }

  my @array_images = @{ $product->{images} };

  push (@array_images, $product->{logo});

  while (my ($key, $value) = each @array_images ) {
    my $url = Mojo::URL->new($value->{path})->userinfo("$self->{user_web_dav}:$self->{password_web_dav}");

    my $tx = $self->{user_agent}->put($url => $value->{binary});

    if ($tx->error) {
      return left($tx->result->message); 
    }
  }

  right(1);
}

1;
