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

    context 'decade discovery' do
      let(:current_decade_start) { Date.today.year / 10 * 10 }

      it 'fills in date in previous decade', js: true do
        # when decade is 2020, date is 2018-01-01
        date = Date.new(current_decade_start - 2, 1, 1)

        select_date date , from: 'Label of my date input'
        expect(subject).to eq date
      end

      it 'fills in date in next decade', js: true do
        # when decade is 2020, date is 2032-01-01
        date = Date.new(current_decade_start + 12, 1, 1)

        select_date date , from: 'Label of my date input'
        expect(subject).to eq date
      end

      it 'fills in date 3 decades in the past', js: true do
        # when decade is 2020, date is 1998-01-01
        date = Date.new(current_decade_start - 22, 1, 1)

        select_date date , from: 'Label of my date input'
        expect(subject).to eq date
      end

      it 'fills in date 3 decades in the future', js: true do
        # when decade is 2020, date is 2052-01-01
        date = Date.new(current_decade_start + 32, 1, 1)

        select_date date , from: 'Label of my date input'
        expect(subject).to eq date
      end
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
end
