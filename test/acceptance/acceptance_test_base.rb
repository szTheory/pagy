require_relative '../test_helper'

require "selenium/webdriver"
Selenium::WebDriver::Firefox::Service.driver_path = '/opt/geckodriver'

require 'capybara'
require 'capybara/dsl'

require 'capybara/minitest'

require 'capybara-screenshot/minitest'

Capybara.asset_host = 'http://localhost:9201'
Capybara.default_driver        = :headless_firefox
Capybara.javascript_driver     = :headless_firefox
Capybara.default_max_wait_time = 20

Capybara.register_driver :headless_firefox do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.firefox
  options      = ::Selenium::WebDriver::Firefox::Options.new(args: %w[-headless],
                                                             profile: 'default')
  Capybara::Selenium::Driver.new app,
                                 browser: :firefox,
                                 desired_capabilities: capabilities,
                                 options: options
end


# CapybaraScrenshot monkey patch fixing bug in Sinatra modular apps
# See https://github.com/mattheworiordan/capybara-screenshot/issues/177
# module Capybara::Screenshot
#   def self.capybara_root
#     @capybara_root = File.dirname(__FILE__)
#   end
# end

# The driver name should match the Capybara driver config name.
Capybara::Screenshot.register_driver(:headless_firefox) do |driver, path|
  driver.browser.save_screenshot(path)
end
# Keep only the screenshots generated from the last failing test suite
Capybara::Screenshot.prune_strategy = :keep_last_run


Capybara.register_driver :headless_chrome do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
  chromeOptions: { args: %w(headless) }
  )

  Capybara::Selenium::Driver.new app,
                                 browser: :chrome,
                                 desired_capabilities: capabilities
end


ENV['APP_ENV'] = 'test'
require_relative './apps/pagy_apps'

class AcceptanceTestBase < Minitest::Spec
  include Capybara::DSL

  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions

  after do
    Capybara.reset_sessions!
  end

  # Capybara.register_driver :chrome do |app|
  #   Capybara::Selenium::Driver.new(app, browser: :chrome)
  # end
  #
  # Capybara.register_driver :headless_chrome do |app|
  #   capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
  #   chromeOptions: { args: %w(headless disable-gpu) }
  #   )
  #
  #   Capybara::Selenium::Driver.new app,
  #                                  browser: :chrome,
  #                                  desired_capabilities: capabilities
  # end
  #
  # Capybara.javascript_driver = :headless_chrome
  # Capybara.default_driver    = :headless_chrome # <-- use Selenium driver
  # Capybara.server = :webrick

end

