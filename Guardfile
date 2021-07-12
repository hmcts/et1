# A sample Guardfile
# More info at https://github.com/guard/guard#readme

guard 'livereload' do
  watch(%r{app/views/.+\.(erb|haml|slim)$})
  watch(%r{app/helpers/.+\.rb})
  watch(%r{app/javascript/.+\.js})
  watch(%r{app/javascript/.+\.css})
  watch(%r{app/javascript/.+\.scss})
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{config/locales/.+\.yml})
  # Rails Assets Pipeline
  watch(%r{(app|vendor)(/assets/\w+/(.+\.([s]?css|js))).*}) { |m| "/assets/#{m[3]}" }
end
