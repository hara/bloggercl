# coding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

describe BloggerCL::Client, '#get_blogs' do
  before do
    consumer = BloggerCL::OAuthHelper.get_consumer('anonymous', 'anonymous')
    token = OAuth::AccessToken.new(consumer, 'token', 'secret')
    @client = BloggerCL::Client.new(token: token)
  end

  context 'with default user' do
    before do
      WebMock.stub_request(:get, 'http://www.blogger.com/feeds/default/blogs')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(body: read_fixture('blogs.xml'))
    end

    it 'returns blogs' do
      blogs = @client.get_blogs
      blogs.first.should be_a_blog
        .with_title("bloggercl test blog 2")
        .with_post_url('http://www.blogger.com/feeds/9999999999999999999/posts/default')
    end
  end

  context 'given a valid user_id' do
    before do
      WebMock.stub_request(:get, 'http://www.blogger.com/feeds/0000000000000000000/blogs')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(body: read_fixture('blogs.xml'))
    end

    it 'returns the blogs' do
      blogs = @client.get_blogs(user_id: '0000000000000000000')
      blogs.first.should be_a_blog
        .with_title("bloggercl test blog 2")
        .with_post_url('http://www.blogger.com/feeds/9999999999999999999/posts/default')
    end
  end

  context 'given a invalid user_id' do
    before do
      WebMock.stub_request(:get, 'http://www.blogger.com/feeds/0000000000000000000/blogs')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(status: 404, body: 'Invalid or unknown user ID string. User ID should be a number, as seen in the Blogger Profile URL.')
    end

    it 'raises HTTPError' do
      expect {
        blogs = @client.get_blogs(user_id: '0000000000000000000')
      }.to raise_error(BloggerCL::HTTPError)
    end
  end
end

