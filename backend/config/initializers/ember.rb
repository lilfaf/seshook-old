EmberCLI.configure do |c|
  c.app :frontend, path: '../frontend', exclude_ember_deps: 'jquery'
end
