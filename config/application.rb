require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Integra2
  #GLOBAL CONSTANTS FOR STOCKS MANAGEMENT
  STOCK_API_URL = 'http://bodega-integracion-2014.herokuapp.com/'
  STOCK_PUBLIC_KEY = 'grupo2'
  STOCK_PRIVATE_KEY = 'CvsDU4MT'
  ALMACEN_DESPACHO = '53571c4f682f95b80b7563e5'
  ALMACEN_PULMON = '53571c52682f95b80b75c0dc'
  ALMACEN_RECEPCION = '5396513be4b0c7adbad816d7'
  ALMACEN_OTRO = '53571c4f682f95b80b7563e6'

  class Application < Rails::Application 
    config.to_prepare do
      # Load application's model / class decorators
      Dir.glob(File.join(File.dirname(__FILE__), "../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end

      # Load application's view overrides
      Dir.glob(File.join(File.dirname(__FILE__), "../app/overrides/*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
  end
end
