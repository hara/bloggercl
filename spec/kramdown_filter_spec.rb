# coding: utf-8

require File.expand_path('../spec_helper', __FILE__)

describe BloggerCL::KramdownFilter do
  describe '.to_html' do
    it 'converts to html' do
      filter = BloggerCL::KramdownFilter
      kramdown = '# Title'
      html = filter.to_html(kramdown)
      html.should eq(%Q|<h1 id="title">Title</h1>\n|)
    end
  end

  describe '.to_text' do
    it 'converts to text' do
      filter = BloggerCL::KramdownFilter
      html = '<h1>Title</h1>'
      text = filter.to_text(html)
      text.should eq("# Title\n\n")
    end
  end
end

