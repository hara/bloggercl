# coding: utf-8

require 'uri'

module BloggerCL
  class Client
    include FeedParser

    attr_accessor :token

    @@urls = {
      blogs: 'http://www.blogger.com/feeds/%s/blogs',
      blog: 'http://www.blogger.com/feeds/%s/blogs/%s',
    }

    @@headers = {
      'Content-Type' => 'application/atom+xml',
      'GData-Version' => '2',
    }

    def initialize(options={})
      @token = options.delete(:token)
    end

    # Creates a new post.
    # @return [Post]
    # @param [Blog] blog
    # @param [Post] post
    def create_post(blog, post, opts={})
      response = token.post(blog.post_url, post.to_atom, @@headers)
      raise_if_http_error(response)
      parse_post(response.body)
    end

    # Updates the post.
    # @return [Post]
    # @param [Post] post
    # @param [Hash] opts
    def update_post(post, opts={})
      response = token.put(post.edit_url, post.to_atom, @@headers)
      raise_if_http_error(response)
      parse_post(response.body)
    end

    # Search posts.
    # @return [Array<Post>]
    # @param [Blog] blog
    # @param [Hash] opts
    # @option opts [String] :id
    # @option opts [String] :category
    # @option opts [Time] :published_min
    # @option opts [Time] :published_max
    # @option opts [Time] :updated_min
    # @option opts [Time] :updated_max
    # @option opts [Integer] :max_results
    # @option opts [Integer] :start_index
    # @option opts [String, Symbol] :orderby
    def search_posts(blog, opts={})
      return get_post(blog.post_url(opts[:id])) if opts[:id]
      url = URI.parse(blog.post_url)
      queries = []
      queries << url.query
      [:category, :max_results, :start_index, :orderby].each do |key|
        queries << "#{key.to_s.gsub('_', '-')}=#{opts[key].to_s}" if opts[key]
      end
      [:published_min, :published_max, :updated_min, :updated_max].each do |key|
        queries << "#{key.to_s.gsub('_', '-')}=#{opts[key].iso8601}" if opts[key]
      end
      url.query = URI.encode(queries.join('&'))
      response = token.get(url.to_s, @@headers)
      raise_if_http_error(response)
      parse_posts(response.body)
    end

    # Gets the post.
    # @return [Post]
    # @param [#to_s] url
    def get_post(url, opts={})
      headers = {}
      headers['If-None-Match'] = opts[:etag] if opts[:etag]
      response = token.get(url, @@headers.merge(headers))
      raise_if_http_error(response)
      parse_post(response.body)
    end

    # Gets blogs.
    # @return [Array<Blog>]
    # @param [Hash] opts
    # @option opts [#to_s] :user_id
    def get_blogs(opts={})
      opts = {
        user_id: 'default'
      }.merge(opts)
      url = @@urls[:blogs] % opts[:user_id]
      response = token.get(url, @@headers)
      raise_if_http_error(response)
      parse_blogs(response.body)
    end

    # Gets the post.
    # @return [Blog]
    # @param [#to_s] blog_id
    # @param [Hash] opts
    # @option opts [#to_s] :user_id
    def get_blog(blog_id, opts={})
      opts = {
        user_id: 'default'
      }.merge(opts)
      url = @@urls[:blog] % [opts[:user_id], blog_id]
      response = token.get(url, @@headers)
      raise_if_http_error(response)
      parse_blog(response.body)
    end

    private

    def raise_if_http_error(response)
      unless response.code =~ /^2\d\d$/
        raise HTTPError.new "#{response.code} #{response.msg}"
      end
    end

    def strong_etag(etag)
      etag.split('W/').last
    end
  end
end

