# PocztaPolska

[Gem at RubyGems.org](https://rubygems.org/gems/poczta_polska) | [Documentation](http://www.rubydoc.info/gems/poczta_polska/0.1.3)

With this gem you can monitor Polish Post parcels and registered mail
as well as packages shipped by Pocztex. It allows you to see basic data
about the consignment as well as all the post offices it has gone through
(including their locations and opening hours). The data is downloaded from
[a public SOAP API of the Polish Post](http://www.poczta-polska.pl/pliki/webservices/Metody%20i%20struktury%20uslugi%20sieciowej%20Poczty%20Polskiej%20SA.pdf)
and wrapped into Ruby classes for your convenience.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'poczta_polska'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install poczta_polska

## Usage

```ruby
require 'poczta_polska'

package_id = 'testp0'
# this package ID generates test data

tr = PocztaPolska.tracker

begin
  pkg = tr.check(package_id)

  puts "A package was sent from #{pkg.office_from} to #{pkg.office_to}."

  pkg.events.each do |event|
    datetime = event.time.strftime("%F, %R")
    puts "Finally:" if event.final?
    puts "Time: #{datetime}"
    puts "Event: #{event.name}"
    puts "Post office: #{event.office}"
    puts
  end

rescue PocztaPolska::UnknownPackageError
  puts "The package couldn't be found"
rescue PocztaPolska::WrongPackageError
  puts "The package ID is wrong"
end

```
## Changelog
### 0.1.0
Initial version.

### 0.1.1
Removed the DynamicReader module and substituded methods defined by it
with explicitly wrote (and documented) methods.

### 0.1.2
Fixed the `Tracker#check_many` method, it didn't work at all before.

### 0.1.3
Fixed more bugs in the `Tracker#check_many` method, created a test suite.

### 0.1.4
Fixed a response parsing error when events are not present.

## Testing

I've created a test suite for all the requests and data structures. You
can run it with `rspec` command, but note that the business API tests won't
work unless you put your credentials in the environment variables `POCZTA_USER` and `POCZTA_PASS`.

## Contributing

1. Fork it (https://github.com/hejmsdz/poczta_polska.rb/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
