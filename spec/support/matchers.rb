# coding: utf-8

RSpec::Matchers.define :be_a_post do |first|
  chain :with_title do |title|
    @title = title
  end

  chain :with_categories do |categories|
    @categories = categories
  end

  chain :with_content_text do |content_text|
    @content_text = content_text
  end

  chain :with_content_html do |content_html|
    @content_html = content_html
  end

  chain :with_draft do
    @draft = true
  end

  chain :with_edit_url do |edit_url|
    @edit_url = edit_url
  end

  chain :with_etag do |etag|
    @etag = etag
  end

  match do |actual|
    actual.is_a?(BloggerCL::Post) &&
      (actual.title == (@title || actual.title)) &&
      (actual.categories == (@categories || actual.categories)) &&
      (actual.content_text == (@content_text || actual.content_text)) &&
      (actual.content_html == (@content_html || actual.content_html)) &&
      (@draft.nil? ? true : actual.draft? == @draft ) &&
      (actual.edit_url == (@edit_url || actual.edit_url)) &&
      (actual.etag == (@etag || actual.etag))
  end
end

RSpec::Matchers.define :be_a_blog do |first|
  chain :with_title do |title|
    @title = title
  end

  chain :with_post_url do |post_url|
    @post_url = post_url
  end

  match do |actual|
    actual.is_a?(BloggerCL::Blog) &&
      (actual.title == (@title || actual.title)) &&
      (actual.post_url == (@post_url || actual.post_url))
  end
end

RSpec::Matchers.define :be_a_feed do |expected|
  match do |actual|
    actual.is_a?(BloggerCL::Feed) &&
      actual.total_results == expected[:total_results] &&
      actual.start_index == expected[:start_index] &&
      actual.items_per_page == expected[:items_per_page]
  end
end
