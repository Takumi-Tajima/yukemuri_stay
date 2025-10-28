RSpec.configure do |config|
  config.before(:each, type: :system) do
    using_driver = ENV['NO_HEADLESS'] ? :chrome : :headless_chrome

    driven_by(:selenium, using: using_driver, screen_size: [1920, 1080])
  end
  config.before(:each, :rack_test, type: :system) do
    driven_by :rack_test
  end
end
