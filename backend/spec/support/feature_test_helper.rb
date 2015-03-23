module FeatureTestHelper
  def search_with_term(resource, terms)
    visit send("admin_#{resource.pluralize}_path")
    fill_in 'Search', with: terms
    click_button 'submit-search'
  end
end

RSpec.configure do |config|
  config.include FeatureTestHelper, type: :feature
end