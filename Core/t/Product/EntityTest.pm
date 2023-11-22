package Product::EntityTest;

use v5.36;
use Test::More;
use lib 'lib/';
use Data::Dump qw(dump);

require_ok('Core::Product::Builder');

my $either = Core::Product::Builder->build({
  title => 'Some title',
  description => 'Some description',
  price => 10.5,
  amount => 120,
  brand => {
    id => 1,
    name => 'Some Brand'
  },
  catalog => {
    id => 1,
    name => 'Some Catalog'
  },
  article => '123345',
  features => [
    {
      title => 'Some Title',
      features => [
        {
          title => 'Some Title',
          text => 'Some Fature Text'
        }
      ]
    }
  ],
  image_path => '/var/www/data',
  logo => {
    filename => 'test.png',
    binary => '
      <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
        <circle cx="50" cy="50" r="40" />
        <circle cx="150" cy="50" r="4" />
        <svg viewBox="0 0 10 10" x="200" width="100">
          <circle cx="5" cy="5" r="4" />
        </svg>
      </svg>
    '
  },
  images => [
    {
      filename => 'test.png',
      binary => '
        <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
          <circle cx="50" cy="50" r="40" />
          <circle cx="150" cy="50" r="4" />
          <svg viewBox="0 0 10 10" x="200" width="100">
            <circle cx="5" cy="5" r="4" />
          </svg>
        </svg>
      ',
    }
  ]
});

ok($either->is_right() eq 1);

# Invalid feature

$either = Core::Product::Builder->build({
  title => 'Some title',
  description => 'Some description',
  price => 10.5,
  amount => 120,
  brand => {
    id => 1,
    name => 'Some Brand'
  },
  catalog => {
    id => 1,
    name => 'Some Catalog'
  },
  article => '123345',
  features => 0,
  image_path => '/var/www/data',
  logo => {
    filename => 'test.png',
    binary => '
      <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
        <circle cx="50" cy="50" r="40" />
        <circle cx="150" cy="50" r="4" />
        <svg viewBox="0 0 10 10" x="200" width="100">
          <circle cx="5" cy="5" r="4" />
        </svg>
      </svg>
    '
  },
  images => [
    {
      filename => 'test.png',
      binary => '
        <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
          <circle cx="50" cy="50" r="40" />
          <circle cx="150" cy="50" r="4" />
          <svg viewBox="0 0 10 10" x="200" width="100">
            <circle cx="5" cy="5" r="4" />
          </svg>
        </svg>
      ',
    }
  ]
});

ok($either->is_left() eq 1);

$either = Core::Product::Builder->build({
  title => 'Some title',
  description => 'Some description',
  price => 10.5,
  amount => 120,
  brand => {
    id => 1,
    name => 'Some Brand'
  },
  catalog => {
    id => 1,
    name => 'Some Catalog'
  },
  article => '123345',
  features => [],
  image_path => '/var/www/data',
  logo => {
    filename => 'test.png',
    binary => '
      <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
        <circle cx="50" cy="50" r="40" />
        <circle cx="150" cy="50" r="4" />
        <svg viewBox="0 0 10 10" x="200" width="100">
          <circle cx="5" cy="5" r="4" />
        </svg>
      </svg>
    '
  },
  images => [
    {
      filename => 'test.png',
      binary => '
        <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
          <circle cx="50" cy="50" r="40" />
          <circle cx="150" cy="50" r="4" />
          <svg viewBox="0 0 10 10" x="200" width="100">
            <circle cx="5" cy="5" r="4" />
          </svg>
        </svg>
      ',
    }
  ]
});

ok($either->is_left() eq 1);

# Invalid images

$either = Core::Product::Builder->build({
  title => 'Some title',
  description => 'Some description',
  price => 10.5,
  amount => 120,
  brand => {
    id => 1,
    name => 'Some Brand'
  },
  catalog => {
    id => 1,
    name => 'Some Catalog'
  },
  article => '123345',
  features => [
    {
      title => 'Some Title',
      features => [
        {
          title => 'Some Title',
          text => 'Some Fature Text'
        }
      ]
    }
  ],
  image_path => '/var/www/data',
  logo => {
    filename => 'test.png',
    binary => '
      <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
        <circle cx="50" cy="50" r="40" />
        <circle cx="150" cy="50" r="4" />
        <svg viewBox="0 0 10 10" x="200" width="100">
          <circle cx="5" cy="5" r="4" />
        </svg>
      </svg>
    '
  },
  images => []
});

ok($either->is_left() eq 1);

$either = Core::Product::Builder->build({
  title => 'Some title',
  description => 'Some description',
  price => 10.5,
  amount => 120,
  brand => {
    id => 1,
    name => 'Some Brand'
  },
  catalog => {
    id => 1,
    name => 'Some Catalog'
  },
  article => '123345',
  features => [
    {
      title => 'Some Title',
      features => [
        {
          title => 'Some Title',
          text => 'Some Fature Text'
        }
      ]
    }
  ],
  image_path => '/var/www/data',
  logo => {
    filename => 'test.png',
    binary => '
      <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
        <circle cx="50" cy="50" r="40" />
        <circle cx="150" cy="50" r="4" />
        <svg viewBox="0 0 10 10" x="200" width="100">
          <circle cx="5" cy="5" r="4" />
        </svg>
      </svg>
    '
  },
  images => 0
});

ok($either->is_left() eq 1);

# Invalid logo

$either = Core::Product::Builder->build({
  title => 'Some title',
  description => 'Some description',
  price => 10.5,
  amount => 120,
  brand => {
    id => 1,
    name => 'Some Brand'
  },
  catalog => {
    id => 1,
    name => 'Some Catalog'
  },
  article => '123345',
  features => [
    {
      title => 'Some Title',
      features => [
        {
          title => 'Some Title',
          text => 'Some Fature Text'
        }
      ]
    }
  ],
  image_path => '/var/www/data',
  logo => undef,
  images => [
    {
      filename => 'test.png',
      binary => '
        <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
          <circle cx="50" cy="50" r="40" />
          <circle cx="150" cy="50" r="4" />
          <svg viewBox="0 0 10 10" x="200" width="100">
            <circle cx="5" cy="5" r="4" />
          </svg>
        </svg>
      ',
    }
  ]
});

ok($either->is_left() eq 1);

# Invalid amount

$either = Core::Product::Builder->build({
  title => 'Some title',
  description => 'Some description',
  price => 10.5,
  amount => -120,
  brand => {
    id => 1,
    name => 'Some Brand'
  },
  catalog => {
    id => 1,
    name => 'Some Catalog'
  },
  article => '123345',
  features => [
    {
      title => 'Some Title',
      features => [
        {
          title => 'Some Title',
          text => 'Some Fature Text'
        }
      ]
    }
  ],
  image_path => '/var/www/data',
  logo => {
    filename => 'test.png',
    binary => '
      <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
        <circle cx="50" cy="50" r="40" />
        <circle cx="150" cy="50" r="4" />
        <svg viewBox="0 0 10 10" x="200" width="100">
          <circle cx="5" cy="5" r="4" />
        </svg>
      </svg>
    '
  },
  images => [
    {
      filename => 'test.png',
      binary => '
        <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
          <circle cx="50" cy="50" r="40" />
          <circle cx="150" cy="50" r="4" />
          <svg viewBox="0 0 10 10" x="200" width="100">
            <circle cx="5" cy="5" r="4" />
          </svg>
        </svg>
      ',
    }
  ]
});

ok($either->is_left() eq 1);

# Invalid price

$either = Core::Product::Builder->build({
  title => 'Some title',
  description => 'Some description',
  price => -10.5,
  amount => 120,
  brand => {
    id => 1,
    name => 'Some Brand'
  },
  catalog => {
    id => 1,
    name => 'Some Catalog'
  },
  article => '123345',
  features => [
    {
      title => 'Some Title',
      features => [
        {
          title => 'Some Title',
          text => 'Some Fature Text'
        }
      ]
    }
  ],
  image_path => '/var/www/data',
  logo => {
    filename => 'test.png',
    binary => '
      <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
        <circle cx="50" cy="50" r="40" />
        <circle cx="150" cy="50" r="4" />
        <svg viewBox="0 0 10 10" x="200" width="100">
          <circle cx="5" cy="5" r="4" />
        </svg>
      </svg>
    '
  },
  images => [
    {
      filename => 'test.png',
      binary => '
        <svg viewBox="0 0 300 100" xmlns="http://www.w3.org/2000/svg" stroke="red" fill="grey">
          <circle cx="50" cy="50" r="40" />
          <circle cx="150" cy="50" r="4" />
          <svg viewBox="0 0 10 10" x="200" width="100">
            <circle cx="5" cy="5" r="4" />
          </svg>
        </svg>
      ',
    }
  ]
});

ok($either->is_left() eq 1);

1;
