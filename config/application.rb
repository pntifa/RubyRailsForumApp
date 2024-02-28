require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Forum
  class Application < Rails::Application
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w(assets tasks))

    config.action_controller.include_all_helpers = false
    
    config.autoload_lib(ignore: %w(assets tasks))
  end
end
