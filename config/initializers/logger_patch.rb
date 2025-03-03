# config/initializers/logger_patch.rb
require 'logger'

module ActiveSupport
  module LoggerThreadSafeLevel
    Logger = ::Logger unless const_defined?(:Logger)
  end
end
