# encoding: utf-8

module DeviseTwitterAnywhere
  module Schema
    def twitter_anywhere_authenticatable
      apply_devise_schema ::Devise.twitter_uid_field, :integer, :limit => 8
    end
  end
end

Devise::Schema.module_eval do
  include DeviseTwitterAnywhere::Schema
end
