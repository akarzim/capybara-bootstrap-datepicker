require 'capybara-bootstrap-datepicker/version'
require 'rspec/core'

module Capybara
  module BootstrapDatepicker
    def select_date(value, datepicker: :bootstrap, format: nil, from: nil, xpath: nil)
      fail "Must pass a hash containing 'from' or 'xpath'" if from.nil? && xpath.nil?

      value = Date.parse(value) unless value.respond_to? :to_date

      date_input = xpath ? find(:xpath, xpath) : find_field(from)

      case datepicker
      when :bootstrap
        select_bootstrap_date date_input, value
      else
        select_simple_date date_input, value
      end
    end

    def select_simple_date(date_input, value)
      value = value.strftime format if format.present?

      date_input.set "#{value}\e"
      first(:xpath, '//body').click
    end

    def select_bootstrap_date(date_input, value)
      date_input.click
      picker = find(:xpath, '//body').find('.datepicker')

      picker_years = picker.find('.datepicker-years', visible: false)
      picker_months = picker.find('.datepicker-months', visible: false)
      picker_days = picker.find('.datepicker-days', visible: false)

      picker_current_decade = picker_years.find('th.datepicker-switch', visible: false)
      picker_current_year = picker_months.find('th.datepicker-switch', visible: false)
      picker_current_month = picker_days.find('th.datepicker-switch', visible: false)

      picker_current_month.click if picker_days.visible?
      picker_current_year.click if picker_months.visible?

      decade_start, decade_end = picker_current_decade.text.split('-').map(&:to_i)

      if value.year < decade_start.to_i
        gap = decade_start / 10 - value.year / 10
        gap.times { picker_years.find('th.prev').click }
      elsif value.year > decade_end
        gap = value.year / 10 - decade_end / 10
        gap.times { picker_years.find('th.next').click }
      end

      picker_years.find('.year', text: value.year).click
      picker_months.find('.month', text: value.strftime('%b')).click
      day_xpath = <<-eos
          .//*[contains(concat(' ', @class, ' '), ' day ')
          and not(contains(concat(' ', @class, ' '), ' old '))
          and not(contains(concat(' ', @class, ' '), ' new '))
          and normalize-space(text())='#{value.day}']
      eos
      picker_days.find(:xpath, day_xpath).trigger :click

      fail if Date.parse(date_input.value) != value
      fail unless page.has_no_css? '.datepicker'
    end
  end
end

RSpec.configure do |c|
  c.include Capybara::BootstrapDatepicker
end
