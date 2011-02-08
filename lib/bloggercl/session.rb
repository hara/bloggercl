# coding: utf-8

module BloggerCL
  class Session
    DEFAULT_PATH = File.expand_path('~/.bloggercl')

    attr_reader :path

    def initialize(path=nil)
      @path = path ? File.expand_path(path) : DEFAULT_PATH
      Dir.mkdir(@path) unless File.exists?(@path)
    end

    def load(id, &block)
      data = {}
      if File.exists? session_filepath(id)
        File.open(session_filepath(id), 'rb') do |f|
          data = Marshal.load(f)
        end
      end
      return data unless block_given?
      block.call(data)
      commit(id, data)
    end

    def commit(id, data)
      File.open(session_filepath(id), 'wb') do |f|
        Marshal.dump(data, f)
      end
      nil
    end

    private

    def session_filepath(id)
      File.join(@path, session_filename(id))
    end

    def session_filename(id)
      if id.to_s.match(/[^0-9A-Za-z_]/)
        raise 'session id must be sequence of alpanumeric characters and underscore'
      end
      "session_#{id}"
    end
  end
end

