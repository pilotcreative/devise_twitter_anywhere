# encoding: utf-8
require "yaml"

#
# Provides basic Twitter functionality. You can ask it for
# the current configuration strings like Twitter.api_key,
# Twitter.application_id and Twitter.application_secret.
#
module DeviseTwitterAnywhere
  module Twitter
    module Config
      class << self

        #
        # Overrides the default configuration file path which is
        # read from when requesting application_id, api_key,
        # application_secret etc.
        #
        #
        #
        attr_accessor :path

        %w(consumer_key consumer_secret).each do |config_key|
          define_method config_key do
            instance_variable_get('@'+config_key) or
            instance_variable_set('@'+config_key, config[config_key].value)
          end
        end

        def sdk_java_script_source
          "http://platform.twitter.com/anywhere.js?id=#{consumer_key}&v=1"
        end

        def twitter_session_name
          "twitter_anywhere_identity"
        end

        private
          def config_file_path
            path || ::Rails.root.join('config', 'twitter.yml')
          end

          def config
            @config ||= YAML.parse_file(config_file_path)[::Rails.env]
          end
      end
    end
  end
end
