# encoding: utf-8
RSpec.describe 'Bootstrap Datepicker', type: :feature do
  before :each do
    Capybara.current_session.driver.visit "#{Capybara.app_host}/bootstrap.html"
  end

  it 'loads the page correctly', js: true do
    expect(page).to have_content 'Bootstrap3 Datepicker'
  end

  it 'fills in an input without using the datepicker', js: true do
    select_date Date.today, from: 'Label of my date input'
    expect(Date.parse find_field('Label of my date input').value).to eq Date.today
  end

  it 'fills in a datepicker based on Bootstrap 3.3', js: true do
    select_date Date.today, from: 'Label of my date input', datepicker: :bootstrap
    expect(Date.parse find_field('Label of my date input').value).to eq Date.today
  end

  it 'fills in a localized datepicker based on Bootstrap 3.3', js: true do
    select_date Date.today, from: 'Label of my localized date input', datepicker: :bootstrap
    expect(Date.parse find_field('Label of my localized date input').value).to eq Date.today
  end

  it 'fills in an input with DateTime object', js: true do
    select_date DateTime.now, from: 'Label of my date input'
    expect(Date.parse find_field('Label of my date input').value).to eq Date.today
  end
end
