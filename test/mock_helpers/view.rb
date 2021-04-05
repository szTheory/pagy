
# frozen_string_literal: true

class MockView
  include Pagy::Frontend

  def initialize(url='http://example.com:3000/foo?page=2')
    @url = url
  end

  def request
    Rack::Request.new(Rack::MockRequest.env_for(@url))
  end

  class Overridden < MockView
    def pagy_get_params(params)
      params.except(:a).merge!(k: 'k')
    end
  end
end
