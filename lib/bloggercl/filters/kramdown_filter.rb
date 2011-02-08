# coding: utf-8

require 'kramdown'

module BloggerCL
  module KramdownFilter
    extend self

    def to_html(text)
      Kramdown::Document.new(text).to_html
    end

    def to_text(html)
      Kramdown::Document.new(html, input: 'html').to_kramdown
    end
  end

  Post.filter = KramdownFilter
end

