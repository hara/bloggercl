# coding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

describe BloggerCL::Client, '#update_post' do
  before do
    consumer = BloggerCL::OAuthHelper.get_consumer('anonymous', 'anonymous')
    token = OAuth::AccessToken.new(consumer, 'token', 'secret')
    @client = BloggerCL::Client.new(token: token)
  end

  context 'given a valid blog and post' do
    before do
      @post = BloggerCL::FeedParser.parse_post(read_fixture('post.xml'))
      WebMock
      .stub_request(:put, 'http://www.blogger.com/feeds/9999999999999999999/posts/default/9999999999999999999')
      .with(headers: {'Content-Type' => 'application/atom+xml'}, body: @post.to_atom)
      .to_return(status: 200, body: read_fixture('post.xml'))
    end

    it 'returns the blog' do
      new_post = @client.update_post(@post)
      new_post.should be_a_post
      .with_title('Second post')
      .with_edit_url('http://www.blogger.com/feeds/9999999999999999999/posts/default/9999999999999999999')
    end
  end
end

