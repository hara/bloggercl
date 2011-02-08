# coding: utf-8

require 'thor'

module BloggerCL
  class CLI < Thor
    desc 'post [FILE]', 'Post an entry'
    method_option :blog, type: :string, aliases: '-b', desc: 'blog'
    method_option :output, type: :string, aliases: '-o', desc: 'output file'
    method_option :overwrite, type: :boolean, default: false, aliases: '-O', desc: 'overwrite input file'
    method_option :verbose, type: :boolean, default: false, aliases: '-v', desc: 'verbose mode'
    def post(file)
      handle_error do
        say version if verbose?
        post = PostSerializer.deserialize(File.read(file))
        client.token = tokens[:default]
        new_post = nil
        if post.edit_url
          say %Q|Updating the post at "#{post.edit_url}" ...| if verbose?
          new_post = client.update_post(post)
        else
          blog = options[:blog] ? client.get_blog(options[:blog]) : client.get_blogs.first
          say %Q|Creating a post to "#{blog.title}" ...| if verbose?
          new_post = client.create_post(blog, post)
        end
        text = PostSerializer.serialize(new_post)
        if options[:output] || options[:overwrite]
          output = options[:output] ? options[:output] : file
          File.open(output, 'wb') {|f| f.write text}
        else
          say text
        end
      end
    end

    desc 'search', 'Search posts'
    method_option :blog, type: :string, aliases: '-b', desc: 'blog'
    method_option :category, type: :string, aliases: '-c', desc: 'category'
    method_option :verbose, type: :boolean, default: false, aliases: '-v', desc: 'verbose mode'
    def search
      handle_error do
        say version if verbose?
        client.token = tokens[:default]
        conditions = {}
        conditions[:category] = options[:category] if options[:category]
        blog = options[:blog] ? client.get_blog(options[:blog]) : client.get_blogs.first
        say %Q|Searching posts of "#{blog.title}" ...| if verbose?
        client.search_posts(blog, conditions).each do |post|
          say "#{post.title}\t#{post.edit_url}"
        end
      end
    end

    desc 'get URL', 'Get the post'
    method_option :verbose, type: :boolean, default: false, aliases: '-v', desc: 'verbose mode'
    def get(url)
      handle_error do
        say version if verbose?
        client.token = tokens[:default]
        post = client.get_post(url)
        say PostSerializer.serialize(post)
      end
    end

    desc 'preview [FILE]', 'Preview the post'
    method_option :verbose, type: :boolean, default: false, aliases: '-v', desc: 'verbose mode'
    def preview(file)
      say version if verbose?
      post = PostSerializer.deserialize(File.read(file))
      say "<h1>#{post.title}</h1>\n"
      say post.content_html
    end

    private

    def handle_error
      begin
        yield
      rescue HTTPError => error
        say error.message
      rescue OAuth::Unauthorized => error
        say 'Unauthorized request'
      end
    end

    def verbose?
      !!options[:verbose]
    end

    def tokens
      @tokens ||= Hash.new do |hash, key|
        hash[key] = get_token(key.to_s.to_sym)
      end
    end

    def get_token(id)
      consumer = OAuthHelper.get_consumer('anonymous', 'anonymous')
      session = Session.new
      token = nil
      session.load(id) do |data|
        say 'Using existing token' if verbose?
        if data[:token] && data[:secret]
          token = OAuth::AccessToken.new(consumer, data[:token], data[:secret])
        else
          say 'Get new token' if verbose?
          request_token = consumer.get_request_token(
            {},
            scope: 'http://www.blogger.com/feeds/',
            xoauth_displayname: displayname,
          )
          say "Please open #{request_token.authorize_url} and authorize data access, enter verifier code."
          token = request_token.get_access_token(oauth_verifier: ask('Verifier code:'))
          data[:token] = token.token
          data[:secret] = token.secret
        end
      end
      token
    end

    def version
      "bloggercl #{VERSION}"
    end

    def displayname
      "bloggercl #{username}@#{hostname}"
    end

    def username
      ENV['USER'] || ENV['USERNAME']
    end

    def hostname
      `hostname`.chomp
    end

    def client
      @client ||= Client.new
    end
  end
end

