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

begin
    require '../keys.rb'

    opts = {
        :protocol => :ftp,        # Protocol used to connect to remote host.
                                  # Possible values are :scp, :sftp and :ftp.
                                  # Of these :scp is the preferred one for
                                  # its stability.
        :host => FtpOptions.host,
        # :port => 22,            # Uncomment this if you need to set port to
                                  # something else than default.
        :user => FtpOptions.user,
        :password => FtpOptions.password,
        :remote => FtpOptions.path,
        :verbose => false,        # if true you get all outputs
        :quiet => false,          # if true outputs only on exceptions.
        :remote_delete => true    # delete the remote file if local file is deleted (defaults to true)
    }

    guard :autoupload, opts do
        watch(/[^.].+/)
        # Restrict root paths starting with "."
    end
rescue Exception => e
    puts 'To use FTP autoload do next:'
    puts '    Create file "/..keys.rb"'
    puts '    Define class FtpOptions with .host, .user, .password methods'
end
