require 'spec_helper'

feature "Viewing Campaigns" do
  scenario "Listing all Campaigns" do
    campaign = Campaign.create(name: 'The Voice', description: "SMS Voting for 'The Voice 2014'", code: 'voice_uk_2014')
    visit '/'
    click_link 'The Voice'
    expect(page.current_url).to eq(campaign_url(campaign))
  end
end
