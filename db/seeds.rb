# db/seeds.rb

AppConfiguration.create!(
  name: 'shipping_rules',
  config_data: {
    "free_shipping_threshold" => 50,
    "shipping_cost" => 5
  },
  version: 1
)

AppConfiguration.create!(
  name: 'ml_pipeline',
config_data: {
    "learning_rate" => 0.001,
    "batch_size" => 32,
    "optimizer" => "adam"
  },
  version: 1
)

puts "Seeded sample configurations."
