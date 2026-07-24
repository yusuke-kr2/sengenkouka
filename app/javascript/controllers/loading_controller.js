import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["spinner", "button"]

  submit() {
    this.spinnerTarget.classList.remove("hidden")
    this.buttonTarget.disabled = true
    this.buttonTarget.classList.add("opacity-50")
  }
}
