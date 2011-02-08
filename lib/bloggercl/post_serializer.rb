# coding: utf-8

module BloggerCL
  class SerializationError < Error; end

  module PostSerializer
    extend self

    def deserialize(text)
      begin
        data = YAML.load(get_yaml(text))
        post = Post.new
        post.title = data['title']
        if data['tags']
          (data['tags'].split(',').map {|t| t.strip} || []).each do |tag|
            post.categories << tag
          end
        end
        post.draft! if data['draft']
        post.links['edit'] = data['url']
        post.etag = data['etag']
        post.published = data['published']
        post.updated = data['updated']
        m = text.match(/^\.\.\.[\r\n]+(.+)/m)
        post.content_text = m[1] if m
        post
      rescue => error
        raise SerializationError.new error.message
      end
    end

    def serialize(post)
      begin
        data = {}
        data['title'] = post.title
        data['tags'] = post.categories.join(', ')
        data['draft'] = post.draft?
        data['url'] = post.edit_url if post.edit_url
        data['etag'] = post.etag if post.etag
        data['published'] = post.published if post.published
        data['updated'] = post.updated if post.updated
        text = YAML.dump_stream(data)
        text << '...' << "\n" << post.content_text
        text
      rescue => error
        raise SerializationError.new error.message
      end
    end

    private

    def get_yaml(text)
        yaml = ''
        text.each_line do |line|
          break if line.match(/^\.{3}$/)
          yaml << line
        end
        yaml
    end
  end
end

