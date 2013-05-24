require "capybara-bootstrap-datepicker/version"
require 'rspec/core'

module Capybara
  module BootstrapDatepicker
    def select_date(value, options = {})
      raise "Must pass a hash containing 'from' or 'xpath'" unless options.is_a?(Hash) and [:from, :xpath].any? { |k| options.has_key? k }

      picker = options.delete :datepicker
      format = options.delete :format
      from = options.delete :from
      xpath = options.delete :xpath

      locator = xpath ? first(:xpath, xpath) : from

      date = value.is_a?(Date) || value.is_a?(Time) ?  value : Date.parse(value)

      date_input = find(:fillable_field, locator, options)

      case picker
      when :bootstrap
        date_input.click
        datepicker = find(:xpath, '//body').find('.datepicker')

        datepicker_years = datepicker.find('.datepicker-years', visible: false)
        datepicker_months = datepicker.find('.datepicker-months', visible: false)
        datepicker_days = datepicker.find('.datepicker-days', visible: false)

        datepicker_current_decade = datepicker_years.find('th.datepicker-switch', visible: false)
        datepicker_current_year = datepicker_months.find('th.datepicker-switch', visible: false)
        datepicker_current_month = datepicker_days.find('th.datepicker-switch', visible: false)

        datepicker_current_month.click if datepicker_days.visible?
        datepicker_current_year.click if datepicker_months.visible?

        decade_start, decade_end = datepicker_current_decade.text.split('-').map &:to_i

        if date.year < decade_start.to_i
          gap = decade_start/10 - date.year/10
          gap.times { datepicker_years.find('th.prev').click }
        elsif date.year > decade_end
          gap = date.year/10 - decade_end/10
          gap.times { datepicker_years.find('th.next').click }
        end

        datepicker_years.find('.year', text: date.year).click
        datepicker_months.find('.month', text: date.strftime("%b")).click
        datepicker_days.find('.day', text: date.day).click
      when :jquery
        raise "jQuery UI datepicker support is not implemented."
      else
        date = date.strftime format unless format.nil?

        date_input.set "#{date}\e"
        first(:xpath, '//body').click
      end
    end
  end
end

RSpec.configure do |c|
  c.include Capybara::BootstrapDatepicker
end

