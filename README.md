[![Gem Version](https://badge.fury.io/rb/capybara-bootstrap-datepicker.svg)](http://badge.fury.io/rb/capybara-bootstrap-datepicker)
[![Travis CI](https://travis-ci.org/akarzim/capybara-bootstrap-datepicker.svg?branch=master)](https://travis-ci.org/akarzim/capybara-bootstrap-datepicker.svg?branch=master)

[Bootstrap]: https://getbootstrap.com/
[bootstrap-datepicker]: https://github.com/eternicode/bootstrap-datepicker
[jQuery]: https://jquery.com/

# Capybara::BootstrapDatepicker

Helper for triggering date input with the [bootstrap-datepicker] JavaScript
library.

This gem does something very simple: it allows you to trigger the [Bootstrap]
date picker to select the date you want.

## Supported versions

This gem has been tested with:

- [Bootstrap] 5.0.1 + [bootstrap-datepicker] 1.9.0 + [jQuery] 3.6.0
- [Bootstrap] 4.4.1 + [bootstrap-datepicker] 1.9.0 + [jQuery] 3.4.1
- [Bootstrap] 3.4.1 + [bootstrap-datepicker] 1.9.0 + [jQuery] 3.4.1

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'capybara-bootstrap-datepicker', group: :test
```

Or, add it into your test group

```ruby
group :test do
    gem 'capybara-bootstrap-datepicker'
    ...
end
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install capybara-bootstrap-datepicker

The gem automatically hooks itself into RSpec helper using `RSpec.configure`.

## Usage

Just use this method inside your Capybara test:

```ruby
select_date(2.weeks.ago, from: "Label of the date input")
```

Or in a more advanced way:

```ruby
select_date(2.weeks.ago, from: "Date", match: :prefer_exact)
select_date(Date.tomorrow, from: "Label of the date input", format: "%d/%m/%Y")
select_date("2013-05-24", xpath: "//path_to//your_date_input", datepicker: :bootstrap)
```

Available options are:

- **from**: the label of your date input
- **xpath**: the path to your date input
- **format**: the format used to fill your date input
- **match**:
- **datepicker**: the way to fill your date input
  - `:bootstrap` = by clicking the popover using [bootstrap-datepicker]
  - `:simple` = just fill the input date
- any extra args to find the input field

## Test

Just run RSpec in your terminal:

    $ rspec

## Upgrading from 0.0.x

RSpec support has been split into a separate file. You'll need to change
`spec_helper.rb` to `require 'capybara-bootstrap-datepicker/rspec'`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
