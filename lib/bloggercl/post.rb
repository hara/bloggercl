# coding: utf-8

require 'cgi'

module BloggerCL
  class Post < Entry
    class << self
      attr_accessor :filter

      def to_html(text)
        filter.to_html(text)
      end

      def to_text(html)
        filter.to_text(html)
      end
    end

    attr_reader :content_text
    attr_reader :content_html

    def initialize
      super
      @draft = false
    end

    def edit_url
      links['edit']
    end

    def edit_url=(url)
      links['edit'] = url
    end

    def content_text=(text)
      @content_text = text
      @content_html = self.class.to_html(text)
      text
    end

    def content_html=(html)
      @content_html = html
      @content_text = self.class.to_text(html)
      html
    end

    def draft?
      !!@draft
    end

    def draft!
      @draft = true
      self
    end

    def publish!
      @draft = false
      self
    end

    def to_atom
      template = <<-EOS
<entry xmlns='http://www.w3.org/2005/Atom' xmlns:app='http://www.w3.org/2007/app'>
  <title type='text'><%=h title %></title>
  <content type='html'>
  <%=h content_html %>
  </content>
  <% categories.each do |category| -%>
    <category scheme='http://www.blogger.com/atom/ns#' term='<%=h category %>' />
  <% end -%>
  <app:control><app:draft><%= draft? ? 'yes' : 'no' %></app:draft></app:control>
</entry>
      EOS
      template = template.gsub(/^\s+/, '').gsub(/[\r\n]/, '')
      ERB.new(template, nil, '-').result(binding)
    end

    private

    def h(value)
      CGI.escapeHTML(value)
    end
  end
end

