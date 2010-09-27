# encoding: utf-8

module DeviseTwitterAnywhere
  module Rails
    module ControllerHelpers
      extend ActiveSupport::Concern

      included do
        helper_method :twitter_session
      end

      def twitter_session
        @twitter_session ||= DeviseTwitterAnywhere::Twitter::Session.new_or_nil_if_invalid(cookies)
      end
    end
  end
end
