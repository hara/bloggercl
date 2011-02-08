# coding: utf-8

require File.expand_path('../../spec_helper', __FILE__)

describe BloggerCL::Client, '#search_posts' do
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
      let(:post) {@client.search_posts(@blog, id: 0)}
    end
  end

  context 'given a category' do
    before do
      WebMock
      .stub_request(:get, 'http://www.blogger.com/feeds/9999999999999999999/posts/default?category=tag1%7Ctag2')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(status: 200, body: read_fixture('posts.xml'))
    end

    it_should_behave_like 'a post feed' do
      let(:feed) {@client.search_posts(@blog, category: 'tag1|tag2')}
    end
  end

  context 'given a published range' do
    before do
      WebMock
      .stub_request(:get, 'http://www.blogger.com/feeds/9999999999999999999/posts/default?published-min=2011-01-01T00:00:00Z&published-max=2011-01-31T00:00:00Z')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(status: 200, body: read_fixture('posts.xml'))
    end

    it_should_behave_like 'a post feed' do
      min = Time.gm(2011, 1, 1)
      max = Time.gm(2011, 1, 31)
      let(:feed) {@client.search_posts(@blog, published_min: min, published_max: max)}
    end
  end

  context 'given a updated range' do
    before do
      WebMock
      .stub_request(:get, 'http://www.blogger.com/feeds/9999999999999999999/posts/default?updated-min=2011-01-01T00:00:00Z&updated-max=2011-01-31T00:00:00Z')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(status: 200, body: read_fixture('posts.xml'))
    end

    it_should_behave_like 'a post feed' do
      min = Time.gm(2011, 1, 1)
      max = Time.gm(2011, 1, 31)
      let(:feed) {@client.search_posts(@blog, updated_min: min, updated_max: max)}
    end
  end

  context 'given a max results and start index' do
    before do
      WebMock
      .stub_request(:get, 'http://www.blogger.com/feeds/9999999999999999999/posts/default?max-results=100&start-index=1')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(status: 200, body: read_fixture('posts.xml'))
    end

    it_should_behave_like 'a post feed' do
      let(:feed) {@client.search_posts(@blog, max_results: 100, start_index: 1)}
    end
  end

  context 'given an order by' do
    before do
      WebMock
      .stub_request(:get, 'http://www.blogger.com/feeds/9999999999999999999/posts/default?orderby=updated')
      .with(headers: {'Content-Type' => 'application/atom+xml'})
      .to_return(status: 200, body: read_fixture('posts.xml'))
    end

    it_should_behave_like 'a post feed' do
      let(:feed) {@client.search_posts(@blog, orderby: :updated)}
    end
  end
end

