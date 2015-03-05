guard 'livereload' do
  watch(%r{backend/app/views/.+\.(erb|haml|slim)$})
  watch(%r{backend/app/helpers/.+\.rb})
  watch(%r{backend/public/.+\.(css|js|html)})
  watch(%r{backend/config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{backend/(app|vendor)(/assets/\w+/(.+\.(css|js|html|png|jpg))).*}) { |m| "/assets/#{m[3]}" }

  # Ember application
  watch %r{frontend/app/\w+/.+\.(js|hbs|html|css)}
end

