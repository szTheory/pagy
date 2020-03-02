require 'rubygems'
require 'bundler'

Bundler.require

# use local pagy
$LOAD_PATH.unshift('lib')
require 'pagy'

# https://github.com/rack/rack/wiki/(tutorial)-rackup-howto
