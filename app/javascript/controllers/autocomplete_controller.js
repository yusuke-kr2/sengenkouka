import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "results"]
  static values = { url: String }

  connect() {
    this.timeout = null
    this.handleClickOutside = this.handleClickOutside.bind(this)
    document.addEventListener("click", this.handleClickOutside)
  }

  disconnect() {
    document.removeEventListener("click", this.handleClickOutside)
  }

  onInput() {
    clearTimeout(this.timeout)
    const query = this.inputTarget.value.trim()

    if (query.length === 0) {
      this.hideResults()
      return
    }

    this.timeout = setTimeout(() => this.fetchSuggestions(query), 300)
  }

  async fetchSuggestions(query) {
    const response = await fetch(`${this.urlValue}?q=${encodeURIComponent(query)}`)
    const names = await response.json()

    if (names.length === 0) {
      this.hideResults()
      return
    }

    this.resultsTarget.innerHTML = names
      .map(name => `<li class="px-4 py-2 text-sm text-gray-700 hover:bg-blue-50 cursor-pointer" data-action="click->autocomplete#select">${this.escapeHtml(name)}</li>`)
      .join("")
    this.resultsTarget.classList.remove("hidden")
  }

  select(event) {
    this.inputTarget.value = event.target.textContent
    this.hideResults()
    this.inputTarget.closest("form").requestSubmit()
  }

  hideResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.add("hidden")
  }

  handleClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hideResults()
    }
  }

  escapeHtml(text) {
    const div = document.createElement("div")
    div.textContent = text
    return div.innerHTML
  }
}
