# encoding: utf-8
require 'devise'

module Devise
  module Models
    module TwitterAnywhereAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_accessor :twitter_session
        define_model_callbacks :create_by_twitter
        define_model_callbacks :connecting_to_twitter
      end

      module ClassMethods
        Devise::Models.config(self,
          :twitter_uid_field, :twitter_auto_create_account, :run_validations_when_creating_twitter_user,
          :skip_confimation_for_twitter_users
        )

        def twitter_auto_create_account?
          !!twitter_auto_create_account
        end

        def authenticate_twitter_user(twitter_uid)
          send("find_by_" + twitter_uid_field.to_s, twitter_uid)
        end
      end

      def set_twitter_credentials_from_session!
        raise "Can't set twitter credentials from session without the session!" if twitter_session.blank?
        send(self.class.twitter_uid_field.to_s+'=', twitter_session.uid)
        make_twitter_model_valid!
      end

      def authenticated_via_twitter?
        read_attribute(self.class.twitter_uid_field).present?
      end

      private
        #
        # In case of model having included other modules like
        # database_authenticate and so on we need to "by pass" some validations etc.
        #
        def make_twitter_model_valid!
          # These database fields are required if authenticable is used
          write_attribute(:password_salt, '') if self.respond_to?(:password_salt)
          write_attribute(:encrypted_password, '') if self.respond_to?(:encrypted_password)

          skip_confirmation! if self.class.skip_confimation_for_twitter_users && respond_to?(:skip_confirmation!)
        end
    end
  end
end
