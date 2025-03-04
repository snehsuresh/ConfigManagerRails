puts "Seeding domain-specific configurations..."

# Shipping Rules - Advanced Example
AppConfiguration.create!(
  name: 'shipping_rules',
  config_data: {
    "region" => "US",
    "carriers" => [
      {
        "name" => "FedEx",
        "service_levels" => [
          {
            "name" => "Standard",
            "base_cost" => 5.0,
            "free_shipping_threshold" => 50.0,
            "delivery_days" => 5
          },
          {
            "name" => "Express",
            "base_cost" => 15.0,
            "free_shipping_threshold" => 100.0,
            "delivery_days" => 2
          }
        ]
      },
      {
        "name" => "UPS",
        "service_levels" => [
          {
            "name" => "Ground",
            "base_cost" => 6.0,
            "free_shipping_threshold" => 60.0,
            "delivery_days" => 5
          },
          {
            "name" => "Next Day Air",
            "base_cost" => 20.0,
            "free_shipping_threshold" => 150.0,
            "delivery_days" => 1
          }
        ]
      }
    ],
    "default_carrier" => "FedEx",
    "holiday_surcharge" => 3.0,
    "international_shipping" => {
      "enabled" => true,
      "base_cost" => 20.0,
      "per_kg_rate" => 5.0,
      "customs_handling_fee" => 10.0
    },
    "tracking_integration" => {
      "enabled" => true,
      "providers" => ["FedEx", "UPS"],
      "webhooks" => {
        "status_update" => "https://your-app.com/webhooks/shipping_status"
      }
    }
  },
  version: 1
)

# Machine Learning Pipeline - Advanced Example
AppConfiguration.create!(
  name: 'ml_pipeline',
  config_data: {
    "pipeline_name" => "text_classification_pipeline",
    "model" => {
      "architecture" => "transformer",
      "backbone" => "bert-base-uncased",
      "pretrained" => true,
      "dropout_rate" => 0.3
    },
    "training" => {
      "batch_size" => 64,
      "learning_rate" => 0.0005,
      "optimizer" => "adamw",
      "lr_scheduler" => "cosine_annealing",
      "epochs" => 50,
      "early_stopping_patience" => 5
    },
    "data" => {
      "train_split" => 0.8,
      "validation_split" => 0.1,
      "test_split" => 0.1,
      "shuffle" => true,
      "augmentation" => {
        "synonym_replacement" => true,
        "back_translation" => true,
        "random_insertion" => false
      }
    },
    "evaluation" => {
      "metrics" => ["accuracy", "f1", "precision", "recall"],
      "confusion_matrix" => true
    },
    "logging" => {
      "tensorboard" => true,
      "log_every_n_steps" => 10
    },
    "deployment" => {
      "docker_image" => "my-ml-pipeline:v1.0",
      "auto_scale" => true,
      "max_replicas" => 10
    }
  },
  version: 1
)

puts "✅ Seeded domain-specific configurations successfully!"
