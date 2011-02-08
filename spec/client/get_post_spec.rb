# coding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

describe BloggerCL::Client, '#get_post' do
  before do
    consumer = BloggerCL::OAuthHelper.get_consumer('anonymous', 'anonymous')
    token = OAuth::AccessToken.new(consumer, 'token', 'secret')
    @client = BloggerCL::Client.new(token: token)
    @blog = BloggerCL::FeedParser.parse_blog(read_fixture('blog.xml'))
  end

  context 'given an id' do
    before do
      WebMock
      .stub_request(:get, 'http://www.blogger.com/feeds/9999999999999999999/posts/default/0')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(status: 200, body: read_fixture('post.xml'))
    end

    it_should_behave_like 'a post' do
      let(:post) {@client.get_post(@blog.post_url(0))}
    end
  end

  context 'given an etag' do
    before do
      WebMock
      .stub_request(:get, 'http://www.blogger.com/feeds/9999999999999999999/posts/default/0')
      .with(headers: {'Content-Type' => 'application/atom+xml', 'If-None-Match' => 'W/"XXXXXXXXXXXXXXXXXXXXXXX."'})
      .to_return(status: 200, body: read_fixture('post.xml'))
    end

    it_should_behave_like 'a post' do
      let(:post) {@client.get_post(@blog.post_url(0), etag: 'W/"XXXXXXXXXXXXXXXXXXXXXXX."')}
    end
  end
end

