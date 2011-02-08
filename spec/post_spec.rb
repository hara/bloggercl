# coding: utf-8

require File.expand_path('../spec_helper', __FILE__)

describe BloggerCL::Post do
  describe '#edit_url' do
    it 'returns edit URL' do
      post = BloggerCL::Post.new
      url = 'http://www.example.org/edit'
      post.links['edit'] = url
      post.edit_url.should eq(url)
    end
  end

  describe '#publish!' do
    it 'publishes the post' do
      post = BloggerCL::Post.new.publish!
      post.draft?.should be_false
    end
  end

  describe '#draft!' do
    it 'drafts the post' do
      post = BloggerCL::Post.new.publish!
      post.draft!
      post.draft?.should be_true
    end
  end

  describe '#content_text=' do
    it 'sets content text' do
      post = BloggerCL::Post.new
      post.content_text = '# Hello'
      post.content_text.should eq('# Hello')
    end

    it 'sets content html' do
      post = BloggerCL::Post.new
      post.content_text = '# Hello'
      post.content_html.should eq(%Q{<h1 id="hello">Hello</h1>\n})
    end
  end

  describe '#content_html=' do
    it 'sets content html' do
      post = BloggerCL::Post.new
      post.content_html = '<h1>Hello</h1>'
      post.content_html.should eq('<h1>Hello</h1>')
    end

    it 'sets content text' do
      post = BloggerCL::Post.new
      post.content_html = '<h1>Hello</h1>'
      post.content_text = "# Hello\n"
    end
  end

  describe '#to_atom' do
    it 'returns atom entry' do
      post = BloggerCL::Post.new
      post.title = 'This is title'
      post.categories << 'tag1'
      post.draft!
      post.content_html = '<p>Hello, world.</p>'

      atom = <<-EOS
<entry xmlns='http://www.w3.org/2005/Atom' xmlns:app='http://www.w3.org/2007/app'><title type='text'>This is title</title><content type='html'>&lt;p&gt;Hello, world.&lt;/p&gt;</content><category scheme='http://www.blogger.com/atom/ns#' term='tag1' /><app:control><app:draft>yes</app:draft></app:control></entry>
      EOS
      atom.chomp!
      post.to_atom.should eq(atom)
    end
  end
end

