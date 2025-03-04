# app/services/shipping_rule_service.rb
class ShippingRuleService
  def initialize(config)
    @config = config
  end

  def shipping_cost(order_total)
    carrier = find_default_carrier
    service_level = find_service_level(carrier, "Standard") # Default to Standard for simulation

    free_shipping_threshold = service_level["free_shipping_threshold"]
    base_cost = service_level["base_cost"]

    cost = order_total >= free_shipping_threshold ? 0 : base_cost
    cost += @config["holiday_surcharge"].to_f if holiday_surcharge_applicable?

    cost
  end

  private

  def find_default_carrier
    carrier_name = @config["default_carrier"]
    @config["carriers"].find { |c| c["name"] == carrier_name } || @config["carriers"].first
  end

  def find_service_level(carrier, level_name)
    carrier["service_levels"].find { |sl| sl["name"] == level_name } || carrier["service_levels"].first
  end

  def holiday_surcharge_applicable?
    # You could make this dynamic in the future (e.g., check if today is a holiday)
    true
  end
end
