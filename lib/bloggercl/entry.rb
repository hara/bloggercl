# coding: utf-8

module BloggerCL
  class Entry
    attr_accessor :id
    attr_accessor :etag
    attr_accessor :title
    attr_accessor :published
    attr_accessor :updated
    attr_reader :links
    attr_reader :categories

    def initialize
      @links = {}
      @categories = []
    end

    def self_url
      links['self']
    end

    alias :url :self_url
  end
end

