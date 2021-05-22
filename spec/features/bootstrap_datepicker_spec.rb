# frozen_string_literal: true

RSpec.shared_examples 'a datepicker' do
  context 'default date' do
    subject { Date.parse(find_field('Label of my date input').value) }

    it 'fills in an input without using the datepicker', js: true do
      select_date Date.today, from: 'Label of my date input'
      expect(subject).to eq Date.today
    end

    it 'fills in a standard datepicker', js: true do
      select_date Date.today, from: 'Label of my date input', datepicker: :simple
      expect(subject).to eq Date.today
    end

    it 'fills in a datepicker based on Bootstrap', js: true do
      select_date Date.today, from: 'Label of my date input', datepicker: :bootstrap
      expect(subject).to eq Date.today
    end

    it 'fills in an input with DateTime object', js: true do
      select_date DateTime.now, from: 'Label of my date input'
      expect(subject).to eq Date.today
    end
  end

  context 'locale date' do
    subject { Date.parse(find_field('Label of my localized date input').value) }

    it 'fills in a localized datepicker based on Bootstrap', js: true do
      select_date Date.today, from: 'Label of my localized date input', datepicker: :bootstrap
      expect(subject).to eq Date.today
    end
  end

  context 'required date' do
    subject { Date.parse(find_field('Start date').value) }

    it 'fills in a required datepicker based on Bootstrap', js: true do
      select_date Date.today, from: 'Start date', datepicker: :bootstrap
      expect(subject).to eq Date.today
    end
  end
end

RSpec.describe 'Bootstrap Datepicker', type: :feature do
  describe 'Boostrap 3.4' do
    before :each do
      Capybara.current_session.driver.visit "#{Capybara.app_host}/bootstrap-3.4.html"
    end

    it 'loads the page correctly', js: true do
      expect(page).to have_content 'Bootstrap 3.4 Datepicker'
    end

    it_behaves_like 'a datepicker'
  end

  describe 'Boostrap 4.4' do
    before :each do
      Capybara.current_session.driver.visit "#{Capybara.app_host}/bootstrap-4.4.html"
    end

    it 'loads the page correctly', js: true do
      expect(page).to have_content 'Bootstrap 4.4 Datepicker'
    end

    it_behaves_like 'a datepicker'
  end

  describe 'Boostrap 5.0' do
    before :each do
      Capybara.current_session.driver.visit "#{Capybara.app_host}/bootstrap-5.0.html"
    end

    it 'loads the page correctly', js: true do
      expect(page).to have_content 'Bootstrap 5.0 Datepicker'
    end

    it_behaves_like 'a datepicker'
  end
end
