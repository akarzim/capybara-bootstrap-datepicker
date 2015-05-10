require 'capybara-bootstrap-datepicker/version'
require 'rspec/core'

module Capybara
  module BootstrapDatepicker
    def select_date(value, datepicker: :bootstrap, format: nil, from: nil, xpath: nil, **args)
      fail "Must pass a hash containing 'from' or 'xpath'" if from.nil? && xpath.nil?

      value = Date.parse(value) unless value.respond_to? :to_date

      date_input = xpath ? find(:xpath, xpath, **args) : find_field(from, **args)

      case datepicker
      when :bootstrap
        select_bootstrap_date date_input, value
      else
        select_simple_date date_input, value
      end

      first(:xpath, '//body').click
    end

    def select_simple_date(date_input, value)
      value = value.strftime format if format.present?

      date_input.set "#{value}\e"
    end

    def select_bootstrap_date(date_input, value)
      date_input.click

      picker = Picker.new

      picker.goto_decade_panel
      picker.navigate_through_decades value.year

      picker.find_year(value.year).click
      picker.find_month(value.strftime('%b')).click
      picker.find_day(value.day).click

      fail if Date.parse(date_input.value) != value
    end

    private
    class Picker
      def initialize
        @element = find_picker
      end

      def goto_decade_panel
        current_month.click if days.visible?
        current_year.click if months.visible?
      end

      def navigate_through_decades(value)
        decade_start, decade_end = current_decade_minmax
        goto_prev_decade(value, decade_start) if value < decade_start
        goto_next_decade(decade_end, value) if value > decade_end
      end

      def find_year(value)
        years.find '.year', text: value
      end

      def find_month(value)
        months.find '.month', text: value
      end

      def find_day(value)
        day_xpath = <<-eos
            .//*[contains(concat(' ', @class, ' '), ' day ')
            and not(contains(concat(' ', @class, ' '), ' old '))
            and not(contains(concat(' ', @class, ' '), ' new '))
            and normalize-space(text())='#{value}']
        eos
        days.find :xpath, day_xpath
      end

      private
      def find_picker
        Capybara.find(:xpath, '//body').find('.datepicker')
      end

      def find_period(period)
        @element.find(".datepicker-#{period}", visible: false)
      end

      def find_switch(period)
        send(period).find('th.datepicker-switch', visible: false)
      end

      def years
        find_period :years
      end

      def months
        find_period :months
      end

      def days
        find_period :days
      end

      def current_decade
        find_switch :years
      end

      def current_year
        find_switch :months
      end

      def current_month
        find_switch :days
      end

      def current_decade_minmax
        current_decade.text.split('-').map(&:to_i)
      end

      def click_prev_decade
        years.find('th.prev').click
      end

      def click_next_decade
        years.find('th.next').click
      end

      def gap(min, max)
        return 0 if min >= max
        max/10 - min/10
      end

      def goto_prev_decade(value, decade_start)
        gap(value, decade_start).times { click_prev_decade }
      end

      def goto_next_decade(decade_end, value)
        gap(decade_end, value).times { click_next_decade }
      end
    end
  end
end

RSpec.configure do |c|
  c.include Capybara::BootstrapDatepicker
end
