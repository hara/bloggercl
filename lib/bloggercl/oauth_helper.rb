# coding: utf-8

module BloggerCL
  module OAuthHelper
    extend self

    SITE = 'https://www.google.com'
    REQUEST_TOKEN_PATH = '/accounts/OAuthGetRequestToken'
    ACCESS_TOKEN_PATH = '/accounts/OAuthGetAccessToken'
    AUTHORIZE_PATH = '/accounts/OAuthAuthorizeToken'

    def get_consumer(consumer_key, consumer_secret, options={})
      options = {
        site: SITE,
        request_token_path: REQUEST_TOKEN_PATH,
        access_token_path: ACCESS_TOKEN_PATH,
        authorize_path: AUTHORIZE_PATH,
      }.merge(options)
      OAuth::Consumer.new(
        consumer_key,
        consumer_secret,
        options
      )
    end
  end
end

