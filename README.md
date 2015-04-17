# Bamboo [![Build Status](https://travis-ci.org/3scale/bamboo-ruby.svg?branch=master)](https://travis-ci.org/3scale/bamboo-ruby)

`bamboo-ruby` is a Ruby client for [Bamboo API](https://github.com/QubitProducts/bamboo#rest-apis).
So far it is not complete, but includes basic functionality to create/update/delete services.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bamboo-ruby'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bamboo-ruby

## Usage

```ruby
require 'bamboo'

client = Bamboo.new('your-bamboo-server.com')
client.create_service(configuration)
client.update_appp(id, configuration)
client.find_app(id)
client.delete_app(id)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/3scale/bamboo-ruby/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
