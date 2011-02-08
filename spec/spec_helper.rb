# coding: utf-8

$:.push File.expand_path('../../lib', __FILE__)
$:.push File.expand_path('..', __FILE__)
require 'bloggercl'
require 'rspec'
require 'webmock/rspec'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

module BloggerCL
  module Test
    module Helper
      def read_fixture(filename)
        File.read(File.join(File.dirname(__FILE__), 'fixtures', filename))
      end
    end
  end
end


RSpec.configure do |config|
  config.include BloggerCL::Test::Helper
end

#
# quick monkey patch for rcov
#
# http://codefluency.com/post/1023734493/a-bandaid-for-rcov-on-ruby-1-9
#
if defined?(Rcov)
  class Rcov::CodeCoverageAnalyzer
    def update_script_lines__
      if '1.9'.respond_to?(:force_encoding)
        SCRIPT_LINES__.each do |k,v|
          v.each { |src| src.force_encoding('utf-8') }
        end
      end
      @script_lines__ = @script_lines__.merge(SCRIPT_LINES__)
    end
  end
end

