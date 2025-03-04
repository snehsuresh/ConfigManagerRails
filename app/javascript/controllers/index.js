import { Application } from "@hotwired/stimulus"
import SimulationController from "./simulation_controller"
import HelloController from "./hello_controller"



window.Stimulus = Application.start()
Stimulus.register("simulation", SimulationController)
Stimulus.register("hello", HelloController)

