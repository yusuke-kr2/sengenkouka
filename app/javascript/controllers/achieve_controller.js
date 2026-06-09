import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "content", "form", "confirm", "congrats"]

  open(event) {
    this.contentTarget.textContent = event.currentTarget.dataset.content
    this.formTarget.action = event.currentTarget.dataset.url
    this.confirmTarget.classList.remove("hidden")
    this.congratsTarget.classList.add("hidden")
    this.modalTarget.classList.remove("hidden")
    document.body.classList.add("overflow-hidden")
  }

  async submit(event) {
    event.preventDefault()
    const form = this.formTarget
    await fetch(form.action, {
      method: "PATCH",
      headers: {
        "X-CSRF-Token": form.querySelector("[name=authenticity_token]").value,
        "Accept": "text/html"
      }
    })
    this.confirmTarget.classList.add("hidden")
    this.congratsTarget.classList.remove("hidden")
  }

  close() {
    this.modalTarget.classList.add("hidden")
    document.body.classList.remove("overflow-hidden")
    window.location.reload()
  }
}
