import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["input", "result"]

    connect() {
        console.log("SimulationController connected!")  // This must show up in DevTools console
    }

    simulate() {
        const orderTotal = parseFloat(this.inputTarget.value)
        console.log("simulate() triggered with orderTotal:", orderTotal)

        if (isNaN(orderTotal)) {
            this.resultTarget.textContent = "Please enter a valid order total."
            return
        }

        fetch(`/api/v1/app_configurations/simulate_shipping.json?order_total=${orderTotal}`)
            .then(response => response.json())
            .then(data => {
                if (data.shipping_cost !== undefined) {
                    this.resultTarget.textContent = `Shipping Cost: $${data.shipping_cost}`
                } else {
                    this.resultTarget.textContent = "Simulation failed (server error)."
                }
            })
            .catch(() => {
                this.resultTarget.textContent = "Simulation failed (connection error)."
            })
    }
}
