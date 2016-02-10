guard 'livereload' do
  watch(%r{.+\.(css|js|html|php|tpl)})
end

guard 'sass', input: 'sass', output: 'css', smart_partials: true

coffeescript_options = {
  input: 'coffee',
  output: 'js',
  patterns: [%r{^coffee/(.+\.(?:coffee|coffee\.md|litcoffee))$}]
}

guard 'coffeescript', coffeescript_options do
  coffeescript_options[:patterns].each { |pattern| watch(pattern) }
end
