require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_text/engine"
require "action_view/railtie"
#require "action_cable/engine"
require "dotenv/load"

Bundler.require(*Rails.groups)

module KanaChampion
  class Application < Rails::Application
    config.load_defaults 8.1

    config.autoload_lib(ignore: %w[assets tasks])

    config.generators do |generator|
      generator.template_engine :slim
      generator.stylesheets false
      generator.helper false
      generator.system_tests = nil
    end
  end
end
