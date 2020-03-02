require_relative './acceptance_test_base'

# pagy initializer
require 'pagy/extras/navs'
require 'pagy/extras/items'

class DemoTest < AcceptanceTestBase

  describe 'only a demo' do

    before do
      Capybara.app = PagyBackendApp.new
    end

    it 'should work'  do
      visit '/helpers'
      assert_content('Pagy Helpers Test')
    end

  end
end
