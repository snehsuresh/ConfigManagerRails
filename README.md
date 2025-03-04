
# Domain-Specific Configuration Management Platform

This project is a full-featured Ruby on Rails 7 application that empowers non-technical users to define and update complex domain-specific configurations. Built with PostgreSQL, this platform allows you to manage settings such as e-commerce shipping rules or ML training hyperparameters with real-time validation, interactive simulation, and robust versioning.

# Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Features](#features)
- [API Documentation](#api-documentation)
- [Demo Video](#demo-video)
- [Contributing](#contributing)
- [License](#license)

# Installation

Follow these steps to get the application up and running on your local machine.

```
# Clone the repository
cd config_manager

# Install Ruby dependencies
bundle install

# Install JavaScript and CSS dependencies
rails javascript:install:esbuild
rails css:install:tailwind

# Create and migrate the database
rails db:create
rails db:migrate

# Seed the database with sample configurations
rails db:seed

# Start the Rails server
rails s
```

# Usage

After installation, you will have a web-based admin interface where you can:
- Create, edit, and delete configurations.
- View configuration details and simulate domain-specific behavior (e.g., shipping cost calculation based on order total).
- Access versioned API endpoints for dynamic consumption of configurations.

### Admin Interface

The home page displays a list of all configurations with details such as ID, name, version, and available actions (Show, Edit, Delete). Clicking on a configuration’s "Show" link displays the configuration details along with a real-time shipping simulation panel.

### Real-Time Simulation

On the "Show" page, there is a simulation section where you can input an order total and see the computed shipping cost based on the defined shipping rules. This interactivity is powered by Turbo and Stimulus for real-time feedback.

# Features

- **Domain-Specific DSL & Business Logic:**  
  Encapsulated in a dedicated service (`ShippingRuleService`), the business logic translates configuration data into actionable shipping cost calculations and validations.

- **Real-Time Validation & Simulation:**  
  With custom JSON schema validations (using `json-schema`) and a dynamic simulation panel, the platform ensures that configurations are correct and immediately shows their impact.

- **Robust Versioning & Audit Trail:**  
  Integrated with the `PaperTrail` gem, every change is versioned, allowing you to track and revert modifications as needed.

- **Dynamic & Flexible Configurations:**  
  By storing configuration data in a `jsonb` field in PostgreSQL, the platform can handle complex, nested domain-specific settings effortlessly.

- **Modern Tech Stack:**  
  Built on Rails 7 using ESBuild, Tailwind CSS, Turbo, and Stimulus for a smooth, responsive UI experience.

- **REST API Endpoints:**  
  Versioned API endpoints (`/api/v1/app_configurations`) allow downstream systems (even Python ML pipelines) to consume configuration data dynamically.

# API Documentation

The following API endpoints are available:

### List Configurations
```
GET http://localhost:3000/api/v1/app_configurations
```

### Show a Configuration
```
GET http://localhost:3000/api/v1/app_configurations/:id
```

### Create a Configuration
```
POST http://localhost:3000/api/v1/app_configurations
Content-Type: application/json

{
  "app_configuration": {
    "name": "shipping_rules",
    "config_data": "{"free_shipping_threshold":50,"shipping_cost":5}"
  }
}
```

### Update a Configuration
```
PATCH http://localhost:3000/api/v1/app_configurations/:id
Content-Type: application/json

{
  "app_configuration": {
    "name": "shipping_rules",
    "config_data": "{"free_shipping_threshold":50,"shipping_cost":3}"
  }
}
```

### Simulate Shipping Cost
```
GET http://localhost:3000/api/v1/app_configurations/simulate_shipping?order_total=45
```

The simulation endpoint returns a JSON response containing the computed shipping cost based on the given order total.

# Demo Video

![Dashboard Demo](./demo.gif)



# Contributing

Contributions are welcome! Please follow these steps to contribute:

1. Fork the repository.
2. Create a new branch for your feature or bug fix.
3. Commit your changes with clear commit messages.
4. Open a pull request explaining your changes.

# License

This project is licensed under the MIT License. See the `LICENSE` file for more details.

# Acknowledgments

- Thanks to the Rails community for providing excellent documentation and support.
- Special thanks to the maintainers of `PaperTrail`, Turbo, Stimulus, and Tailwind CSS for their amazing tools.
