# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Integra2::Application.initialize!
#gema para tareas recurrentes
config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'
