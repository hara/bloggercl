# coding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

describe BloggerCL::Client, '#get_blog' do
  before do
    consumer = BloggerCL::OAuthHelper.get_consumer('anonymous', 'anonymous')
    token = OAuth::AccessToken.new(consumer, 'token', 'secret')
    @client = BloggerCL::Client.new(token: token)
  end

  context 'given a valid blog_id' do
    before do
      WebMock.stub_request(:get, 'http://www.blogger.com/feeds/default/blogs/9999999999999999999')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(body: read_fixture('blog.xml'))
    end

    it 'returns the blog' do
      blog = @client.get_blog('9999999999999999999')
      blog.should be_a_blog
      .with_title("bloggercl test blog 1")
      .with_post_url('http://www.blogger.com/feeds/9999999999999999999/posts/default')
    end
  end

  context 'given a invalid blog_id' do
    before do
      WebMock.stub_request(:get, 'http://www.blogger.com/feeds/default/blogs/9999999999999999999')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(status: 400, body: 'Invalid entry id specified')
    end

    it 'raises HTTPError' do
      expect {
        blog = @client.get_blog('9999999999999999999')
      }.to raise_error(BloggerCL::HTTPError)
    end
  end

  context 'given a valid user_id' do
    before do
      WebMock.stub_request(:get, 'http://www.blogger.com/feeds/0000000000000000000/blogs/9999999999999999999')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(body: read_fixture('blog.xml'))
    end

    it 'returns the blogs' do
      blog = @client.get_blog('9999999999999999999', user_id: '0000000000000000000')
      blog.should be_a_blog
      .with_title("bloggercl test blog 1")
      .with_post_url('http://www.blogger.com/feeds/9999999999999999999/posts/default')
    end
  end

  context 'given a invalid user_id' do
    before do
      WebMock.stub_request(:get, 'http://www.blogger.com/feeds/0000000000000000000/blogs/9999999999999999999')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(status: 404, body: 'Invalid or unknown user ID string. User ID should be a number, as seen in the Blogger Profile URL.')
    end

    it 'raises HTTPError' do
      expect {
        blog = @client.get_blog('9999999999999999999', user_id: '0000000000000000000')
      }.to raise_error(BloggerCL::HTTPError)
    end
  end
end

