# app/models/configuration.rb
require 'json-schema'

class AppConfiguration < ApplicationRecord
  # Validate config_data JSON against a schema based on the configuration name.
  validate :validate_config_schema
  before_save :parse_config_data

  private

  def parse_config_data
    if config_data.is_a?(String)
      self.config_data = JSON.parse(config_data)
    end
  end

def validate_config_schema
  schema = {}

  begin
    if config_data.is_a?(String)
      self.config_data = JSON.parse(config_data)
    end
  rescue JSON::ParserError => e
    errors.add(:config_data, "is not valid JSON: #{e.message}")
    return # Don't continue schema validation if parsing failed
  end

  case name
  when 'shipping_rules'
    schema = {
      "type" => "object",
      "required" => ["free_shipping_threshold", "shipping_cost"],
      "properties" => {
        "free_shipping_threshold" => { "type" => "number" },
        "shipping_cost" => { "type" => "number" }
      }
    }
  when 'ml_pipeline'
    schema = {
      "type" => "object",
      "required" => ["learning_rate", "batch_size", "optimizer"],
      "properties" => {
        "learning_rate" => { "type" => "number" },
        "batch_size" => { "type" => "integer" },
        "optimizer" => { "type" => "string" }
      }
    }
  else
    return # No schema — skip validation
  end

  begin
    JSON::Validator.validate!(schema, config_data)
  rescue JSON::Schema::ValidationError => e
    errors.add(:config_data, e.message)
  end
end

end
