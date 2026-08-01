import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "count"]
  static values = { max: { type: Number, default: 200 } }

  connect() {
    this.update()
  }

  update() {
    const remaining = this.maxValue - this.inputTarget.value.length
    this.countTarget.textContent = remaining
    this.countTarget.classList.toggle("text-red-500", remaining < 0)
    this.countTarget.classList.toggle("text-gray-400", remaining >= 0)
  }
}
