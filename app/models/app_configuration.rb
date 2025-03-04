# app/models/app_configuration.rb
require 'json-schema'

class AppConfiguration < ApplicationRecord
  has_paper_trail

  validate :validate_config_schema
  before_validation :ensure_valid_json
  after_initialize :set_default_version, if: :new_record?
  before_save :increment_version
  before_save :force_version_bump

  private

  def force_version_bump
    self.version = (self.version.to_i + 1)
  end

  def increment_version
    if persisted? && changed?
      self.version = (self.version.presence || 0) + 1
    end
  end






  def set_default_version
    self.version ||= 1
  end



  def ensure_valid_json
    if config_data.is_a?(String)
      begin
        self.config_data = JSON.parse(config_data)
      rescue JSON::ParserError
        errors.add(:config_data, "Invalid JSON format")
      end
    end
  end

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
      return # Skip schema validation if parsing failed
    end

    case name
    when 'shipping_rules'
      schema = {
        "type" => "object",
        "required" => ["region", "carriers", "default_carrier", "tracking_integration"],
        "properties" => {
          "region" => { "type" => "string" },
          "carriers" => {
            "type" => "array",
            "items" => {
              "type" => "object",
              "required" => ["name", "service_levels"],
              "properties" => {
                "name" => { "type" => "string" },
                "service_levels" => {
                  "type" => "array",
                  "items" => {
                    "type" => "object",
                    "required" => ["name", "base_cost", "free_shipping_threshold", "delivery_days"],
                    "properties" => {
                      "name" => { "type" => "string" },
                      "base_cost" => { "type" => "number" },
                      "free_shipping_threshold" => { "type" => "number" },
                      "delivery_days" => { "type" => "integer" }
                    }
                  }
                }
              }
            }
          },
          "default_carrier" => { "type" => "string" },
          "holiday_surcharge" => { "type" => "number" },
          "international_shipping" => {
            "type" => "object",
            "required" => ["enabled", "base_cost", "per_kg_rate", "customs_handling_fee"],
            "properties" => {
              "enabled" => { "type" => "boolean" },
              "base_cost" => { "type" => "number" },
              "per_kg_rate" => { "type" => "number" },
              "customs_handling_fee" => { "type" => "number" }
            }
          },
          "tracking_integration" => {
            "type" => "object",
            "required" => ["enabled", "providers", "webhooks"],
            "properties" => {
              "enabled" => { "type" => "boolean" },
              "providers" => {
                "type" => "array",
                "items" => { "type" => "string" }
              },
              "webhooks" => {
                "type" => "object",
                "required" => ["status_update"],
                "properties" => {
                  "status_update" => { "type" => "string" }
                }
              }
            }
          }
        }
      }
    when 'ml_pipeline'
      schema = {
        "type" => "object",
        "required" => ["pipeline_name", "model", "training", "data", "evaluation", "logging", "deployment"],
        "properties" => {
          "pipeline_name" => { "type" => "string" },
          "model" => {
            "type" => "object",
            "required" => ["architecture", "backbone", "pretrained", "dropout_rate"],
            "properties" => {
              "architecture" => { "type" => "string" },
              "backbone" => { "type" => "string" },
              "pretrained" => { "type" => "boolean" },
              "dropout_rate" => { "type" => "number" }
            }
          },
          "training" => {
            "type" => "object",
            "required" => ["batch_size", "learning_rate", "optimizer", "lr_scheduler", "epochs", "early_stopping_patience"],
            "properties" => {
              "batch_size" => { "type" => "integer" },
              "learning_rate" => { "type" => "number" },
              "optimizer" => { "type" => "string" },
              "lr_scheduler" => { "type" => "string" },
              "epochs" => { "type" => "integer" },
              "early_stopping_patience" => { "type" => "integer" }
            }
          },
          "data" => {
            "type" => "object",
            "required" => ["train_split", "validation_split", "test_split", "shuffle", "augmentation"],
            "properties" => {
              "train_split" => { "type" => "number" },
              "validation_split" => { "type" => "number" },
              "test_split" => { "type" => "number" },
              "shuffle" => { "type" => "boolean" },
              "augmentation" => {
                "type" => "object",
                "properties" => {
                  "synonym_replacement" => { "type" => "boolean" },
                  "back_translation" => { "type" => "boolean" },
                  "random_insertion" => { "type" => "boolean" }
                }
              }
            }
          },
          "evaluation" => {
            "type" => "object",
            "required" => ["metrics", "confusion_matrix"],
            "properties" => {
              "metrics" => {
                "type" => "array",
                "items" => { "type" => "string" }
              },
              "confusion_matrix" => { "type" => "boolean" }
            }
          },
          "logging" => {
            "type" => "object",
            "required" => ["tensorboard", "log_every_n_steps"],
            "properties" => {
              "tensorboard" => { "type" => "boolean" },
              "log_every_n_steps" => { "type" => "integer" }
            }
          },
          "deployment" => {
            "type" => "object",
            "required" => ["docker_image", "auto_scale", "max_replicas"],
            "properties" => {
              "docker_image" => { "type" => "string" },
              "auto_scale" => { "type" => "boolean" },
              "max_replicas" => { "type" => "integer" }
            }
          }
        }
      }
    else
      return # Skip validation if no schema is defined
    end

    begin
      JSON::Validator.validate!(schema, config_data)
    rescue JSON::Schema::ValidationError => e
      errors.add(:config_data, e.message)
    end
  end
end
