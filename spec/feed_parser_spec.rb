# coding: utf-8

require File.expand_path('../spec_helper', __FILE__)

describe BloggerCL::FeedParser do
  describe '#parse_blogs' do
    context 'given a valid format feed' do
      it_should_behave_like 'a blog feed' do
        let(:feed) {BloggerCL::FeedParser.parse_blogs(read_fixture('blogs.xml'))}
      end
    end

    context 'given an invalid format feed' do
      it 'raises ParseError' do
        expect {
          BloggerCL::FeedParser.parse_blogs('<feed></fee>')
        }.to raise_error(BloggerCL::ParseError)
      end
    end
  end

  describe '#parse_blog' do
    context 'given a valid format feed' do
      it_should_behave_like 'a blog' do
        let(:blog) {BloggerCL::FeedParser.parse_blog(read_fixture('blog.xml'))}
      end
    end

    context 'given an invalid format feed' do
      it 'raises ParseError' do
        expect {
          BloggerCL::FeedParser.parse_blog('<feed></fee>')
        }.to raise_error(BloggerCL::ParseError)
      end
    end
  end

  describe '#parse_posts' do
    context 'given a valid format feed' do
      it_should_behave_like 'a post feed' do
        let(:feed) {BloggerCL::FeedParser.parse_posts(read_fixture('posts.xml'))}
      end
    end

    context 'given an invalid format feed' do
      it 'raises ParseError' do
        expect {
          BloggerCL::FeedParser.parse_posts('<feed></fee>')
        }.to raise_error(BloggerCL::ParseError)
      end
    end
  end

  describe '#parse_post' do
    context 'given a valid format feed' do
      it_should_behave_like 'a post' do
        let(:post) {BloggerCL::FeedParser.parse_post(read_fixture('post.xml'))}
      end
    end

    context 'given an invalid format feed' do
      it 'raises ParseError' do
        expect {
          BloggerCL::FeedParser.parse_post('<feed></fee>')
        }.to raise_error(BloggerCL::ParseError)
      end
    end
  end
end

