# coding: utf-8

shared_examples_for 'a post' do
  it 'is a post' do
    post.should be_a_post
    .with_title('Second post')
    .with_content_html(read_fixture('post.html').chomp)
    .with_categories(%w(tag1 tag2))
    .with_edit_url('http://www.blogger.com/feeds/9999999999999999999/posts/default/9999999999999999999')
    .with_etag('W/"XXXXXXXXXXXXXXXXXXXXXXX."')
  end
end

shared_examples_for 'a post feed' do
  it 'is a feed' do
    feed.should be_a_feed(total_results: 2, start_index: 1, items_per_page: 25)
  end

  it 'has 2 posts' do
    feed[0].should be_a_post
      .with_title('Second post')
      .with_content_html(read_fixture('post.html').chomp)
      .with_categories(%w(tag1 tag2))
      .with_edit_url('http://www.blogger.com/feeds/9999999999999999999/posts/default/9999999999999999999')
      .with_etag('W/"XXXXXXXXXXXXXXXXXXXXXXX."')

    feed[1].should be_a_post
      .with_title('First post')
      .with_content_html(read_fixture('post.html').chomp)
      .with_categories(%w(tag1 tag2))
      .with_edit_url('http://www.blogger.com/feeds/9999999999999999999/posts/default/9999999999999999999')
      .with_etag('W/"XXXXXXXXXXXXXXXXXXXXXXX."')
  end
end

shared_examples_for 'a blog' do
  it 'is a blog' do
    blog.should be_a_blog
      .with_title('bloggercl test blog 1')
      .with_post_url('http://www.blogger.com/feeds/9999999999999999999/posts/default')
  end
end

shared_examples_for 'a blog feed' do
  it 'is a feed' do
    feed.should be_a_feed(total_results: 2, start_index: 1, items_per_page: 25)
  end

  it 'has 2 blogs' do
    feed[0].should be_a_blog
      .with_title("bloggercl test blog 2")
      .with_post_url('http://www.blogger.com/feeds/9999999999999999999/posts/default')

    feed[1].should be_a_blog
      .with_title("bloggercl test blog 1")
      .with_post_url('http://www.blogger.com/feeds/8888888888888888888/posts/default')
  end
end
