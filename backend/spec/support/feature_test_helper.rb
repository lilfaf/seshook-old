module FeatureTestHelper
  def login_for(email, password)
    visit new_admin_session_path
    fill_in 'Email', with: email
    fill_in 'Password', with: password
    click_button 'Log in'
  end

  def search_with_term(resource, terms)
    visit send("admin_#{resource.pluralize}_path")
    fill_in 'Search', with: terms
    click_button 'submit-search'
  end
end

RSpec.configure do |config|
  config.include FeatureTestHelper, type: :feature
end