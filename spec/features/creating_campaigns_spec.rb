require "spec_helper"

feature "Creating Campaigns" do
  scenario 'can create a new campaign' do
    visit '/'
#    save_and_open_page

    click_link 'New Campaign'

    fill_in 'Name', with: 'The Voice'
    fill_in 'Description', with: "SMS Voting for 'The Voice 2014'"
    fill_in 'Code', with: 'voice_uk_2014'

    click_button 'Create Campaign'

    expect(page).to have_content('Campaign created.')
    expect(page).to have_content('The Voice')
  end
end
