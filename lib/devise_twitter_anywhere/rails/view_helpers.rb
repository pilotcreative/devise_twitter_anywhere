# encoding: utf-8

module DeviseTwitterAnywhere
  module Rails
    module ViewHelpers
      #
      # Inserts twitter HTML and javascript tag for initializing
      # JavaScript SDK. See http://developers.twitter.com/docs/authentication/: Single Sign-on.
      #
      # Some options to this helper-method might be added in the future :-)
      #
      def twitter_init_javascript_sdk
        javascript_include_tag(DeviseTwitterAnywhere::Twitter::Config.sdk_java_script_source).html_safe
      end
    end
  end
end
