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

# opts = {
#     :protocol => :scp,        # Protocol used to connect to remote host.
#                               # Possible values are :scp, :sftp and :ftp.
#                               # Of these :scp is the preferred one for
#                               # its stability.
#     :host => "diane.timeweb.ru",
#     # :port => 22,            # Uncomment this if you need to set port to
#                               # something else than default.
#     :user => "cy44684",
#     :password => "password",
#     :remote => "remote_path",
#     :verbose => false,        # if true you get all outputs
#     :quiet => false,          # if true outputs only on exceptions.
#     :remote_delete => true    # delete the remote file if local file is deleted (defaults to true)
# }

# guard :autoupload, opts do
#     watch(/^((?!Guardfile$).)*$/)
#     # Matches every other file but Guardfile. This way we don't
#     # accidentally upload the credentials.
# end
