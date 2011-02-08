# coding: utf-8

require 'rexml/document'
require 'cgi'

module BloggerCL
  class ParseError < Error; end

  module FeedParser
    extend self

    def parse_blogs(feed)
      handle_error do
        doc = REXML::Document.new(feed)
        blogs = parse_feed(doc.root)
        REXML::XPath.each(doc, '/feed/entry') do |node|
          blogs << parse_entry(node, Blog.new)
        end
        blogs
      end
    end

    def parse_blog(feed)
      handle_error do
        doc = REXML::Document.new(feed)
        blog = parse_entry(doc.root, Blog.new)
      end
    end

    def parse_posts(feed)
      handle_error do
        doc = REXML::Document.new(feed)
        posts = parse_feed(doc.root)
        REXML::XPath.each(doc, '/feed/entry') do |node|
          post = parse_entry(node, Post.new)
          content = node.elements['content']
          post.content_html = content ?
            CGI.unescapeHTML(replace_more content.text) : ''
          post.draft! if REXML::XPath.first(node, 'app:control/app:draft/text()') == 'yes'
          posts << post
        end
        posts
      end
    end

    def parse_post(feed)
      handle_error do
        doc = REXML::Document.new(feed)
        post = parse_entry(doc.root, Post.new)
        content = doc.root.elements['content']
        post.content_html = content ?
          CGI.unescapeHTML(replace_more content.text) : ''
        post.draft! if REXML::XPath.first(doc, '/entry/app:control/app:draft/text()') == 'yes'
        post
      end
    end

    private

    def replace_more(text)
      text.gsub("<a name='more'></a>", '<!-- more -->')
          .gsub('<a name="more"></a>', '<!-- more -->')
    end

    def parse_entry(node, entry)
      entry.etag = (node.attributes['gd:etag'] || '')

      title = node.elements['title']
      entry.title = title ? title.text : ''

      updated = node.elements['updated']
      entry.updated = updated ? Time.parse(updated.text) : nil

      published = node.elements['published']
      entry.published = published ? Time.parse(published.text) : nil

      node.each_element('category') do |category|
        entry.categories << category.attributes['term']
      end

      node.each_element('link') do |link|
        entry.links[link.attributes['rel']] = link.attributes['href']
      end
      entry
    end

    def parse_feed(node)
      feed = Feed.new

      feed.total_results = node.elements['openSearch:totalResults'].text.to_i
      feed.start_index = node.elements['openSearch:startIndex'].text.to_i
      feed.items_per_page = node.elements['openSearch:itemsPerPage'].text.to_i

      feed
    end

    def handle_error(&block)
      begin
        block.call
      rescue => error
        raise ParseError.new error.message
      end
    end
  end
end

