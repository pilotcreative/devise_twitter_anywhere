module DeviseTwitterAnywhere
  module Twitter
    extend ActiveSupport::Autoload

    autoload :Config
    autoload :Session
  end

  module Rails
    extend ActiveSupport::Autoload

    autoload :ViewHelpers
    autoload :ControllerHelpers
  end
end

require 'devise_twitter_anywhere/rails'
require 'devise_twitter_anywhere/strategy'
require 'devise_twitter_anywhere/schema'

module Devise
  #
  # Specifies database column name to store the twitter user id.
  #
  mattr_accessor :twitter_uid_field
  @@twitter_uid_field = :twitter_uid

  #
  # Instructs this gem to auto create an account for twitter
  # users which have not visited before
  #
  mattr_accessor :twitter_auto_create_account
  @@twitter_auto_create_account = true

  #
  # Runs validation when auto creating users on twitter
  #
  mattr_accessor :run_validations_when_creating_twitter_user
  @@run_validations_when_creating_twitter_user = false

  #
  # Skip confirmation loop on twitter connection users
  #
  mattr_accessor :skip_confimation_for_twitter_users
  @@skip_confimation_for_twitter_users = true
end

Devise.add_module(:twitter_anywhere_authenticatable,
  :strategy => true,
  :controller => :sessions,
  :model => 'devise_twitter_anywhere/model'
)
