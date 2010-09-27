# encoding: utf-8

require 'devise/strategies/base'

module Devise
  module TwitterAnywhereAuthenticatable
    module Strategies
      class TwitterAnywhereAuthenticatable < ::Devise::Strategies::Base
        #
        # This strategy is valid if Facebook has set it's session data object in
        # current application's domain cookies.
        #
        def valid?
          mapping.to.respond_to?(:authenticate_twitter_user) && cookies.has_key?(::DeviseTwitterAnywhere::Twitter::Config.twitter_session_name)
        end

        #
        # Authenticates the user as if this requests seems
        # valid as TwitterAnywhereAuthenticatable
        #
        # Tries to auto create the user if configured to do so.
        #
        def authenticate!
          session = DeviseTwitterAnywhere::Twitter::Session.new(cookies, params)

          if session.valid?
            klass = mapping.to
            user = klass.authenticate_twitter_user session.uid

            if user.blank? && klass.twitter_auto_create_account?
              user = klass.new
              user.twitter_session = session
              user.set_twitter_credentials_from_session!
              user.run_callbacks :create_by_twitter do
                begin
                  user.save(:validate => klass.run_validations_when_creating_twitter_user)
                rescue ActiveRecord::RecordNotUnique
                  fail!(:not_unique_user_on_creation) and return
                end
              end

              if klass.run_validations_when_creating_twitter_user && !user.persisted?
                fail!(:invalid_twitter_user_on_creation) and return
              end
            end

            if user.present? && user.persisted?
              user.twitter_session = session
              user.run_callbacks :connecting_to_twitter do
                success!(user) and return
              end
            else
              fail!(:twitter_user_not_found_locally) and return
            end
          else
            fail!(:invalid_twitter_session) and return
          end
        end
      end
    end
  end
end

::Warden::Strategies.add(:twitter_anywhere_authenticatable, Devise::TwitterAnywhereAuthenticatable::Strategies::TwitterAnywhereAuthenticatable)
