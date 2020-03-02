# This is a Sinatra app used to test Pagy

require "sinatra/base"
require "sinatra/reloader"

require 'pagy'

class PagyBaseApp < Sinatra::Base

  require_relative '../../mock_helpers/collection'

  configure do
    enable :inline_templates
    # set :server, :puma
    # set :root, File.dirname(__FILE__)
  end

  configure :development do
    register Sinatra::Reloader
  end

  get '/pagy.js' do
    content_type 'application/javascript'
    send_file Pagy.root.join('javascripts', 'pagy.js')
  end

end

# TODO: copy each app into its own test file (including the eventual inline templates)

class PagyBackendApp < PagyBaseApp
  require 'pagy/extras/navs'
  require 'pagy/extras/items'

  include Pagy::Backend
  include Pagy::Frontend

  get '/helpers' do
    collection = MockCollection.new
    @pagy, _   = pagy(collection)
    erb :helpers
  end

  get '/no-pagy' do

  end

end

# # no need of this app, since there is no javascript execution, nor headers involved in metadata (already unit-tested)
# class PagyJsFrontendApp < PagyBaseApp
#   require 'pagy/extras/metadata'
#   require 'json'
#
#   include Pagy::Backend
#
#   get '/metadata' do
#     collection    = MockCollection.new
#     pagy, records = pagy(collection)
#
#     content_type :json
#     {data: records, pagy: pagy_metadata(pagy)}.to_json
#   end
#
# end

# no frontend + headers extra
class PagyApiApp < PagyBaseApp
  require 'pagy/extras/headers'
  require 'json'

  include Pagy::Backend

  get '/headers' do
    collection    = MockCollection.new
    pagy, records = pagy(collection)
    pagy_headers_merge(pagy)
    content_type :json
    records.to_json
  end
end



__END__

@@ layout
<html>
<head>
  <script type="application/javascript" src="/pagy.js"></script>
  <script type="application/javascript">
    window.addEventListener("load", Pagy.init);
  </script>
</head>
<body>
  <%= yield %>
</body>
</html>

@@ helpers
Pagy Helpers Test
<%= pagy_nav_js(@pagy) %>
<%= pagy_combo_nav_js(@pagy) %>
<%= pagy_items_selector_js(@pagy) %>

@@ no-pagy
<p>Just a page without pagy</p>
