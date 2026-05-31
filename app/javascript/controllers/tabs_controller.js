import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  switch(event) {
    const selected = event.currentTarget.dataset.tab

    this.tabTargets.forEach(tab => {
      const active = tab.dataset.tab === selected
      if (tab.dataset.tabStyle === "card") {
        tab.classList.toggle("border-2", active)
        tab.classList.toggle("border-blue-600", active)
        tab.classList.toggle("border", !active)
        tab.classList.toggle("border-gray-200", !active)
        const label = tab.querySelector("[data-tab-label]")
        if (label) {
          label.classList.toggle("text-blue-600", active)
          label.classList.toggle("text-gray-400", !active)
        }
      } else {
        tab.classList.toggle("border-blue-600", active)
        tab.classList.toggle("text-blue-600", active)
        tab.classList.toggle("border-transparent", !active)
        tab.classList.toggle("text-gray-500", !active)
      }
    })

    this.panelTargets.forEach(panel => {
      panel.classList.toggle("hidden", panel.dataset.panel !== selected)
    })
  }
}
