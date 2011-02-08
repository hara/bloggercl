# coding: utf-8

module BloggerCL
  class Blog < Entry
    def initialize
      super
    end

    def post_url(post_id=nil)
      url = links[links.keys.find {|k| k.ends_with? '#post'}]
      post_id ? "#{url}/#{post_id.to_s}" : url
    end
  end
end

