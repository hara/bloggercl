# coding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

describe BloggerCL::Client, '#create_post' do
  before do
    consumer = BloggerCL::OAuthHelper.get_consumer('anonymous', 'anonymous')
    token = OAuth::AccessToken.new(consumer, 'token', 'secret')
    @client = BloggerCL::Client.new(token: token)
  end

  context 'given a valid blog and post' do
    before do
      @blog = BloggerCL::FeedParser.parse_blog(read_fixture('blog.xml'))
      @post = BloggerCL::PostSerializer.deserialize(read_fixture('post.yml'))
      WebMock
      .stub_request(:post, 'http://www.blogger.com/feeds/9999999999999999999/posts/default')
      .with(headers: {'Content-Type' => 'application/atom+xml'}, body: @post.to_atom)
      .to_return(status: 201, body: read_fixture('post.xml'))
    end

    it 'returns the blog' do
      new_post = @client.create_post(@blog, @post)
      new_post.should be_a_post
      .with_title('Second post')
      .with_edit_url('http://www.blogger.com/feeds/9999999999999999999/posts/default/9999999999999999999')
    end
  end
end

