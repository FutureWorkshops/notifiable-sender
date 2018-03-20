# Notifiable::Sender

Wrapper for the notifiable notifications API. Use this to send notifications from Ruby code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'notifiable-sender'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install notifiable-sender

## Usage

```ruby
notifiable = Notifiable::Sender.new(ENV['notifiable_access_id'])
notifiable.send_notification(message: 'Hello notifiable')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/FutureWorkshops/notifiable-sender.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

