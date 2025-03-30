# frozen_string_literal: true

require 'timecop'

RSpec.shared_examples 'a datepicker' do
  before do
    Timecop.travel(Time.local(2023, 3, 31))
  end

  context 'with default date' do
    subject { Date.parse(find_field('Label of my date input').value) }

    it 'fills in an input without using the datepicker', :js do
      select_date Date.today, from: 'Label of my date input'
      expect(subject).to eq Date.today
    end

    it 'fills in a standard datepicker', :js do
      select_date Date.today, from: 'Label of my date input', datepicker: :simple
      expect(subject).to eq Date.today
    end

    it 'fills in a datepicker based on Bootstrap', :js do
      select_date Date.today, from: 'Label of my date input', datepicker: :bootstrap
      expect(subject).to eq Date.today
    end

    it 'fills in an input with DateTime object', :js do
      select_date DateTime.now, from: 'Label of my date input'
      expect(subject).to eq Date.today
    end
  end

  context 'when decade discovery' do
    subject { Date.parse(find_field('Label of my date input').value) }

    it 'fills in date in previous decade', :js do
      date = Date.new(2018)

      select_date date, from: 'Label of my date input'
      expect(subject).to eq date
    end

    it 'fills in date in current decade', :js do
      date = Date.new(2021)

      select_date date, from: 'Label of my date input'
      expect(subject).to eq date
    end

    it 'fills in date in next decade', :js do
      date = Date.new(2032)

      select_date date, from: 'Label of my date input'
      expect(subject).to eq date
    end

    it 'fills in date 3 decades in the past', :js do
      date = Date.new(1998)

      select_date date, from: 'Label of my date input'
      expect(subject).to eq date
    end

    it 'fills in date 3 decades in the future', :js do
      date = Date.new(2052)

      select_date date, from: 'Label of my date input'
      expect(subject).to eq date
    end
  end

  context 'with dialog callback' do
    subject { Date.parse(find_field('Label of date input with dialog callback').value) }

    it 'fills in a datepicker while passing alert dialog', :js do
      accept_alert 'Date has changed' do
        select_date Date.today, from: 'Label of date input with dialog callback', datepicker: :simple
      end

      expect(subject).to eq Date.today
    end

    it 'fills in a datepicker while passing alert dialog on Bootstrap', :js do
      accept_alert 'Date has changed' do
        select_date Date.today, from: 'Label of date input with dialog callback', datepicker: :bootstrap
      end

      expect(subject).to eq Date.today
    end
  end

  context 'with locale date' do
    subject { Date.parse(find_field('Label of my localized date input').value) }

    it 'fills in a localized datepicker based on Bootstrap', :js do
      select_date Date.today, from: 'Label of my localized date input', datepicker: :bootstrap
      expect(subject).to eq Date.today
    end
  end

  context 'with required date' do
    subject { Date.parse(find_field('Start date').value) }

    it 'fills in a required datepicker based on Bootstrap', :js do
      select_date Date.today, from: 'Start date', datepicker: :bootstrap
      expect(subject).to eq Date.today
    end
  end

  context 'with yyyy-mm format' do
    subject { Date.strptime(find_field('Label of my date input with YYYY-MM format').value, '%Y-%m') }

    it 'fills in a date without day', :js do
      select_date Date.today, from: 'Label of my date input with YYYY-MM format', datepicker: :simple, format: '%Y-%m'
      expect(subject).to eq Date.new(2023, 3)
    end

    it 'fills in a date without day on Bootstrap', :js do
      select_date Date.today, from: 'Label of my date input with YYYY-MM format', datepicker: :bootstrap, format: '%Y-%m'
      expect(subject).to eq Date.new(2023, 3)
    end
  end
end

RSpec.describe 'Bootstrap Datepicker', type: :feature do
  browsers = %i[firefox chrome]
  bootstrap_versions = ['3.4', '4.4', '5.0', '5.3']

  browsers.each do |browser|
    describe "Driven by #{browser}" do
      before do
        Capybara.current_driver = browser
        Capybara.javascript_driver = browser
      end

      bootstrap_versions.each do |version|
        describe "Boostrap #{version}" do
          before do
            Capybara.current_session.driver.visit "#{Capybara.app_host}/bootstrap-#{version}.html"
          end

          it 'loads the page correctly', :js do
            expect(page).to have_content "Bootstrap #{version} Datepicker"
          end

          it_behaves_like 'a datepicker'
        end
      end
    end
  end
end
