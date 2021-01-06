require 'capybara-bootstrap-datepicker/version'

module Capybara
  # Adds datepicker interaction facilities to {Capybara}
  module BootstrapDatepicker
    # Selects a date by simulating human interaction with the datepicker or filling the input field
    # @param value [#to_date, String] any object that responds to `#to_date` or a parsable date string
    # @param datepicker [:bootstrap, :simple] the datepicker to use (are supported: bootstrap or input field)
    # @param format [String, nil] a valid date format used to format value
    # @param from [String, nil] the path to input field (required if `xpath` is nil)
    # @param xpath [String, nil] the xpath to input field (required if `from` is nil)
    # @param args [Hash] extra args to find the input field
    def select_date(value, datepicker: :bootstrap, format: nil, from: nil, xpath: nil, **args)
      fail "Must pass a hash containing 'from' or 'xpath'" if from.nil? && xpath.nil?

      value = value.respond_to?(:to_date) ? value.to_date : Date.parse(value)
      date_input = xpath ? find(:xpath, xpath, **args) : find_field(from, **args)

      case datepicker
      when :bootstrap
        select_bootstrap_date date_input, value, format: format
      else
        select_simple_date date_input, value, format
      end

      first(:xpath, '//body').click
    end

    # Selects a date by filling the input field
    # @param date_input the input field
    # @param value [Date] the date to set
    # @param format [String, nil] a valid date format used to format value
    def select_simple_date(date_input, value, format = nil)
      value = value.strftime format unless format.nil?

      date_input.set "#{value}\e"
    end

    # Selects a date by simulating human interaction with the datepicker
    # @param (see #select_simple_date)
    def select_bootstrap_date(date_input, value, format: nil)
      date_input.click

      picker = Picker.new

      picker.goto_decade_panel
      picker.navigate_through_decades value.year

      picker.find_year(value.year).click
      picker.find_month(value.month).click
      picker.find_day(value.day).click if format.nil? || format.include?('%d')

      fail if (format.nil? ? Date.parse(date_input.value) : Date.strptime(date_input.value, format)) != value
    end

    private

    # The Picker class interacts with the datepicker
    class Picker
      # Initializes the picker
      def initialize
        @element = find_picker
      end

      # Reveals the decade panel
      def goto_decade_panel
        current_month.click if days.visible?
        current_year.click if months.visible?
      end

      # Navigates through the decade panels until the correct one
      # @param value [Fixnum] the year of the desired date
      def navigate_through_decades(value)
        decade_start, decade_end = current_decade_minmax
        goto_prev_decade(value, decade_start) if value < decade_start
        goto_next_decade(decade_end, value) if value > decade_end
      end

      # Get the year we want to click on
      # @param value [Fixnum] the year of the desired date
      # @return the DOM element to click on
      def find_year(value)
        years.find '.year', text: value
      end

      # Get the month we want to click on
      # @param value [Fixnum] the month of the desired date
      # @return the DOM element to click on
      def find_month(value)
        months.find ".month:nth-child(#{value})"
      end

      # Get the day we want to click on
      # @param value [Fixnum] the day of the desired date
      # @return the DOM element to click on
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

      # Get the datepicker
      # @return the DOM element of the datepicker
      def find_picker
        Capybara.find(:xpath, '//body').find('.datepicker')
      end

      # Get the datepicker panel
      # @param period [:years, :months, :days] the panel's period
      # @return the DOM element of the panel
      def find_period(period)
        @element.find(".datepicker-#{period}", visible: false)
      end

      # Get the up level panel
      # @param (see #find_period)
      # @return the DOM element of the switch panel button
      def find_switch(period)
        send(period).find('th.datepicker-switch', visible: false)
      end

      # Get the years panel
      # @param (see #find_period)
      # @return (see #find_period)
      def years
        find_period :years
      end

      # Get the months panel
      # @param (see #find_period)
      # @return (see #find_period)
      def months
        find_period :months
      end

      # Get the days panel
      # @param (see #find_period)
      # @return (see #find_period)
      def days
        find_period :days
      end

      # Get the current decade panel
      # @param (see #find_switch)
      # @return (see #find_switch)
      def current_decade
        find_switch :years
      end

      # Get the current year panel
      # @param (see #find_switch)
      # @return (see #find_switch)
      def current_year
        find_switch :months
      end

      # Get the current month panel
      # @param (see #find_switch)
      # @return (see #find_switch)
      def current_month
        find_switch :days
      end

      # Get the current decade period
      # @return [Array<Fixnum, Fixnum>] the min and max years of the decade
      def current_decade_minmax
        current_decade.text.split('-').map(&:to_i)
      end

      # Click and display previous decade
      def click_prev_decade
        years.find('th.prev').click
      end

      # Click and display next decade
      def click_next_decade
        years.find('th.next').click
      end

      # Calculates the distance in decades between min and max
      # @return [Fixnum] the distance in decades between min and max
      def gap(min, max)
        return 0 if min >= max
        (max - min) / 10
      end

      # Go backward to the wanted decade
      # @param value [Fixnum] the year of the desired date
      # @param decade_start [Fixnum] the first year of a decade
      def goto_prev_decade(value, decade_start)
        gap(value, decade_start).times { click_prev_decade }
      end

      # Go forward to the wanted decade
      # @param decade_end [Fixnum] the last year of a decade
      # @param value [Fixnum] the year of the desired date
      def goto_next_decade(decade_end, value)
        gap(decade_end, value).times { click_next_decade }
      end
    end
  end
end
