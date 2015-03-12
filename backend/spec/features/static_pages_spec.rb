require 'rails_helper'

describe 'static pages' do
  it 'can visit about page' do
    visit root_path
    click_link 'About'
    expect(page.current_path).to eq('/about')
    expect(page).to have_content('About Us')
  end

  it 'can visit contact page' do
    visit root_path
    click_link 'Contact'
    expect(page.current_path).to eq('/contact')
    expect(page).to have_content('Contact Us')
  end

  it 'can visit privacy page' do
    visit root_path
    click_link 'Privacy'
    expect(page.current_path).to eq('/privacy')
    expect(page).to have_content('Privacy Policy')
  end

  it 'can visit about page' do
    visit root_path
    click_link 'Terms'
    expect(page.current_path).to eq('/terms')
    expect(page).to have_content('Terms & Conditions')
  end
end
