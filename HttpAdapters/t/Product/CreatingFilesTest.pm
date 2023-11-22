package Product::CreatingFilesTest;

use v5.36;
use Test::More;
use Data::Dump qw(dump);
use Mojo::EventEmitter;

use lib 'lib/';

my $event_emiter = Mojo::EventEmitter->new;

require_ok('Core::Product::Entity');
require_ok('HttpAdapters::Product::CreatingFiles');

my $ENV = Dotenv->parse('.env' );

my $adapter = HttpAdapters::Product::CreatingFiles->new({
  user_web_dav => $ENV->{USER},
  password_web_dav => $ENV->{PASSWORD}
});

my $either_product = Core::Product::Entity->build({
  title => 'Some title',
  description => 'Some description',
  price => 10.5,
  amount => 120,
  features => {
    'Some title' => 'Some feature',
    Title => 'Some feature'
  },
  image_path => $ENV->{URL},
  logo => {
    filename => 'test.svg',
    binary => '<?xml version="1.0" encoding="utf-8"?>
            <!-- Generator: SVG Repo -->
            <svg width="800px" height="800px" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg">
                <path fill="#494c4e" d="M15 9a1 1 0 0 1-1 1h-4v4a1 1 0 0 1-2 0v-4H4a1 1 0 0 1 0-2h4V4a1 1 0 0 1 2 0v4h4a1 1 0 0 1 1 1z"/>
            </svg>'
  },
  images => [
    {
      filename => 'test.svg',
      binary => '<?xml version="1.0" encoding="utf-8"?>
            <!-- Generator: SVG Repo -->
            <svg width="800px" height="800px" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg">
                <path fill="#494c4e" d="M15 9a1 1 0 0 1-1 1h-4v4a1 1 0 0 1-2 0v-4H4a1 1 0 0 1 0-2h4V4a1 1 0 0 1 2 0v4h4a1 1 0 0 1 1 1z"/>
            </svg>',
    },
    {
      filename => 'test.svg',
      binary => '<?xml version="1.0" encoding="utf-8"?>
            <!-- Generator: SVG Repo -->
            <svg width="800px" height="800px" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg">
                <path fill="#494c4e" d="M15 9a1 1 0 0 1-1 1h-4v4a1 1 0 0 1-2 0v-4H4a1 1 0 0 1 0-2h4V4a1 1 0 0 1 2 0v4h4a1 1 0 0 1 1 1z"/>
            </svg>',
    }
  ]
});

my $either = $adapter->create($either_product->value);

ok($either->is_right() eq 1);

$either_product = Core::Product::Entity->build({
  title => 'Some title',
  description => 'Some description',
  price => 10.5,
  amount => 120,
  features => {
    'Some title' => 'Some feature',
    Title => 'Some feature'
  },
  image_path => 'http://192.168.0.161:8100',
  logo => {
    filename => 'test.svg',
    binary => '<?xml version="1.0" encoding="utf-8"?>
            <!-- Generator: SVG Repo -->
            <svg width="800px" height="800px" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg">
                <path fill="#494c4e" d="M15 9a1 1 0 0 1-1 1h-4v4a1 1 0 0 1-2 0v-4H4a1 1 0 0 1 0-2h4V4a1 1 0 0 1 2 0v4h4a1 1 0 0 1 1 1z"/>
            </svg>'
  },
  images => [
    {
      filename => 'test.svg',
      binary => '<?xml version="1.0" encoding="utf-8"?>
            <!-- Generator: SVG Repo -->
            <svg width="800px" height="800px" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg">
                <path fill="#494c4e" d="M15 9a1 1 0 0 1-1 1h-4v4a1 1 0 0 1-2 0v-4H4a1 1 0 0 1 0-2h4V4a1 1 0 0 1 2 0v4h4a1 1 0 0 1 1 1z"/>
            </svg>',
    },
    {
      filename => 'test.svg',
      binary => '<?xml version="1.0" encoding="utf-8"?>
            <!-- Generator: SVG Repo -->
            <svg width="800px" height="800px" viewBox="0 0 18 18" xmlns="http://www.w3.org/2000/svg">
                <path fill="#494c4e" d="M15 9a1 1 0 0 1-1 1h-4v4a1 1 0 0 1-2 0v-4H4a1 1 0 0 1 0-2h4V4a1 1 0 0 1 2 0v4h4a1 1 0 0 1 1 1z"/>
            </svg>',
    }
  ]
});

$either = $adapter->create($either_product->value);

ok($either->is_left() eq 1);

1;