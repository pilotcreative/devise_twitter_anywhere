# encoding: utf-8

module DeviseTwitterAnywhere
  module Twitter
    class Session
      #
      # Keys found in cookie content. We are supplying reader
      # methods for these values which are read from cookie content
      #
      TWITTER_SESSION_KEYS = %w(uid signature)

      def self.new_or_nil_if_invalid(cookies)
        session = new(cookies)
        return session if session.valid?
      end

      #
      # Creates a new Facebook session based cookies hash from a request
      #
      def initialize(cookies, params)
        @cookies = cookies
        @params = params
      end

      #
      # Returns facebook's cookie content
      #
      def cookie_content
        @cookie_content ||= parse_cookie
      end

      def params_content
        @params_content ||= parse_params
      end

      #
      # Gives access to query as user with an oauth access token fetched from the cookie content
      #
      def oauth
        ::OAuth::Consumer.new(Config.consumer_key, Config.consumer_secret, :site => "https://api.twitter.com")
      end

      def oauth_tokens
        @oauth_tokens ||= Rack::Utils.parse_query(oauth.request(:post, "/oauth/access_token", nil, {}, {"oauth_bridge_code" => oauth_bridge_code}).body)
      end

      def oauth_token
        oauth_tokens["oauth_token"]
      end

      def oauth_token_secret
        oauth_tokens["oauth_token_secret"]
      end

      def oauth_bridge_code
        @params[:oauth_bridge_code]
      end

      #
      # Define reader methods for facebook session keys
      #
      TWITTER_SESSION_KEYS.each do |key|
        define_method key do
          cookie_content[key] if cookie_content
        end
      end

      #
      # Is this a valid session? True if we were able to parse facebook's cookie content
      #
      def valid?
        !!cookie_content
      end

      private
        def parse_cookie # :nodoc:
          components = {}
          components["uid"], components["signature"] = @cookies[Config.twitter_session_name].to_s.split(":")
          return components if components["signature"] == Digest::SHA1.hexdigest(%Q{#{components["uid"]}#{Config.consumer_secret}})
          raise "Authentication via Twitter Anywhere failed. Your cookie may have been forged."
        end
    end
  end
end
