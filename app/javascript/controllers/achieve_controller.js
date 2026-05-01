import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "content", "form"]

  open(event) {
    this.contentTarget.textContent = event.currentTarget.dataset.content
    this.formTarget.action = event.currentTarget.dataset.url
    this.modalTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
  }
}
