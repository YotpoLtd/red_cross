# RedCross

This Gem reports events to segment - to be added:
Sending events to an event collector which will use Kafka

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'red_cross'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install red_cross

## Usage

In your apps boot process you should add the following:

```ruby
require 'red_cross/trackers/influx_db'
require 'red_cross/trackers/typhoeus'
require 'red_cross/trackers/segment'
require 'red_cross/trackers/log'

RedCross.configure = RedCross::Configuration.new do |builder|
  builder.provider :segment, ENV['SEGMENT_WRITE_KEY']
  builder.provider :typhoeus, ENV['CLERK_URL']
  builder.provider :influxdb, ENV['INFLUXDB_HOST'], ENV['INFLUXDB_PORT'], ENV['INFLUXDB_DB']
  builder.provider :log, 'logs/red_cross.log', 'project_name'
  builder.logger = Logger.new(STDOUT)
end
```

Once added you can do this anywhere you like in your code

```ruby
RedCross.track('event')
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/red_cross. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

