# encoding: utf-8
RSpec.describe 'Bootstrap Datepicker', type: :feature do
  it 'fill in datepicker based on Bootstrap 3.3', js: true do
    Capybara.current_session.driver.visit "#{Capybara.app_host}/bootstrap.html"
    expect(page).to have_content 'Bootstrap3 Datepicker'

    select_date Date.today, from: 'Label of my date input', datepicker: :bootstrap
    expect(Date.parse find_field('Label of my date input').value).to eq Date.today
  end
end

