# coding: utf-8

require File.expand_path('../spec_helper', __FILE__)

describe BloggerCL::PostSerializer do
  describe '#deserialize' do
    context 'given a YAML contains post' do
      it 'deserializes from YAML' do
        post = BloggerCL::PostSerializer.deserialize(read_fixture('post.yml'))
        content = read_fixture('post.mkd')
        post.should be_a_post
          .with_title('Hello, world.')
          .with_categories(%w(tag1 tag2))
          .with_content_text(content)
          .with_draft
      end
    end

    context 'given a YAML contains post with url' do
      it 'deserializes from YAML' do
        post = BloggerCL::PostSerializer.deserialize(read_fixture('post_for_update.yml'))
        content = read_fixture('post.mkd')
        post.should be_a_post
          .with_title('Hello, world.')
          .with_categories(%w(tag1 tag2))
          .with_content_text(content)
          .with_draft
          .with_edit_url('http://www.blogger.com/feeds/9999999999999999999/posts/default/9999999999999999999')
          .with_etag('W/"XXXXXXXXXXXXXXXXXXXXXXX."')
      end
    end

    context 'given an invalid YAML' do
      it 'raises SerializationError' do
        yaml = '- hello'
        expect {
          BloggerCL::PostSerializer.deserialize(yaml)
        }.to raise_error(BloggerCL::SerializationError)
      end
    end
  end

  describe '#serialize' do
    it 'serializes to YAML' do
      post = BloggerCL::Post.new
      post.title = 'Hello, world'
      post.categories << 'tag1' << 'tag2'
      post.content_text = read_fixture('post.mkd')
      post.draft!
      post.edit_url = 'http://www.blogger.com/feeds/9999999999999999999/posts/default/9999999999999999999'
      text = BloggerCL::PostSerializer.serialize(post)
      new_post = BloggerCL::PostSerializer.deserialize(text)
      new_post.should be_a_post
        .with_title(post.title)
        .with_categories(post.categories)
        .with_content_text(post.content_text)
        .with_draft
        .with_edit_url('http://www.blogger.com/feeds/9999999999999999999/posts/default/9999999999999999999')
    end
  end
end

