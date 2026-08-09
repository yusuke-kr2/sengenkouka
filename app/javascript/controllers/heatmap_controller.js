import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { data: Object }

  connect() {
    const today = new Date()
    this.selectedYear = today.getFullYear()
    this.selectedMonth = today.getMonth()

    this.tooltip = document.createElement("div")
    this.tooltip.className = "fixed z-50 bg-gray-800 text-white text-xs rounded px-2 py-1 pointer-events-none hidden whitespace-nowrap"
    document.body.appendChild(this.tooltip)

    this.render()
  }

  disconnect() {
    this.tooltip?.remove()
  }

  isMobile() {
    return (this.element.clientWidth || 320) < 600
  }

  render() {
    if (this.isMobile()) {
      this.renderMobile()
    } else {
      this.renderDesktop()
    }
    this.attachTooltips()
  }

  // ── モバイル：月タブ + 月カレンダー ───────────────────────

  renderMobile() {
    const today = new Date()

    // 直近12ヶ月分のタブ
    const months = []
    for (let i = 11; i >= 0; i--) {
      const d = new Date(today.getFullYear(), today.getMonth() - i, 1)
      months.push({ year: d.getFullYear(), month: d.getMonth() })
    }

    let html = '<div class="flex overflow-x-auto gap-1.5 pb-2" style="scrollbar-width:none;-webkit-overflow-scrolling:touch">'
    months.forEach(({ year, month }) => {
      const isSelected = year === this.selectedYear && month === this.selectedMonth
      html += `<button
        class="shrink-0 px-3 py-1 rounded-full text-xs font-medium transition-colors ${isSelected ? 'bg-blue-600 text-white' : 'bg-gray-100 text-gray-600'}"
        data-year="${year}" data-month="${month}"
        data-action="click->heatmap#selectMonth">
        ${this.monthName(month)}
      </button>`
    })
    html += '</div>'

    html += this.buildMonthGrid(this.selectedYear, this.selectedMonth)
    html += this.buildLegend()

    this.element.innerHTML = html
  }

  selectMonth(event) {
    this.selectedYear = parseInt(event.currentTarget.dataset.year)
    this.selectedMonth = parseInt(event.currentTarget.dataset.month)
    this.render()
  }

  buildMonthGrid(year, month) {
    const data = this.dataValue
    const today = new Date()
    const firstDay = new Date(year, month, 1)
    const lastDay = new Date(year, month + 1, 0)
    const dayLabels = ['日', '月', '火', '水', '木', '金', '土']

    let html = '<div class="w-full mb-2">'

    // 曜日ヘッダー
    html += '<div class="grid grid-cols-7 mb-1">'
    dayLabels.forEach(d => {
      html += `<div class="text-center text-xs text-gray-400 py-0.5">${d}</div>`
    })
    html += '</div>'

    // 日付グリッド
    html += '<div class="grid grid-cols-7 gap-0.5">'

    // 月初の曜日オフセット
    for (let i = 0; i < firstDay.getDay(); i++) {
      html += '<div class="h-8"></div>'
    }

    for (let day = 1; day <= lastDay.getDate(); day++) {
      const date = new Date(year, month, day)
      const dateStr = this.formatDate(date)
      const status = data[dateStr] || null
      const isFuture = date > today
      const colorClass = isFuture ? 'bg-gray-50' : this.getColor(status, true)
      const label = !isFuture ? `${dateStr}${status ? ` · ${this.statusLabel(status)}` : ''}` : ''
      html += `<div class="h-8 rounded-sm ${colorClass} flex items-center justify-center cursor-default" data-label="${label}">
        <span class="text-xs ${status && !isFuture ? 'text-gray-600 font-bold' : 'text-gray-400'}">${day}</span>
      </div>`
    }

    html += '</div></div>'
    return html
  }

  // ── デスクトップ：年間ヒートマップ ────────────────────────

  renderDesktop() {
    const data = this.dataValue
    const today = new Date()
    const startDate = new Date(today)
    startDate.setDate(startDate.getDate() - 364)
    const dayOfWeek = startDate.getDay()
    startDate.setDate(startDate.getDate() - dayOfWeek)
    const rangeStart = new Date(startDate)

    const weeks = []
    let current = new Date(startDate)

    while (current <= today) {
      const week = []
      for (let i = 0; i < 7; i++) {
        const dateStr = this.formatDate(current)
        const isInRange = current >= rangeStart && current <= today
        week.push({ date: dateStr, status: data[dateStr] || null, inRange: isInRange })
        current.setDate(current.getDate() + 1)
      }
      weeks.push(week)
    }

    const monthLabels = this.buildMonthLabels(weeks)

    let html = '<div class="overflow-x-auto"><div class="inline-flex flex-col gap-0.5">'

    html += '<div class="flex gap-0.5 mb-1">'
    monthLabels.forEach(label => {
      html += `<span class="text-xs text-gray-400" style="width:${label.span * 13}px;white-space:nowrap;overflow:hidden">${label.name}</span>`
    })
    html += '</div>'

    html += '<div class="flex gap-0.5">'
    weeks.forEach(week => {
      html += '<div class="flex flex-col gap-0.5">'
      week.forEach(day => {
        const colorClass = this.getColor(day.status, day.inRange)
        const label = day.inRange ? `${day.date}${day.status ? ` · ${this.statusLabel(day.status)}` : ''}` : ''
        html += `<div class="w-3 h-3 rounded-sm ${colorClass} cursor-default" data-label="${label}"></div>`
      })
      html += '</div>'
    })
    html += '</div>'

    html += this.buildLegend()
    html += '</div></div>'

    this.element.innerHTML = html
  }

  // ── 共通 ──────────────────────────────────────────────────

  buildLegend() {
    return `<div class="flex items-center gap-2 mt-2">
      <div class="w-3 h-3 rounded-sm bg-blue-200"></div><span class="text-xs text-gray-400 mr-1">宣言中</span>
      <div class="w-3 h-3 rounded-sm bg-green-400"></div><span class="text-xs text-gray-400 mr-1">達成</span>
      <div class="w-3 h-3 rounded-sm bg-red-300"></div><span class="text-xs text-gray-400">未達成</span>
    </div>`
  }

  attachTooltips() {
    this.element.querySelectorAll("[data-label]").forEach(el => {
      el.addEventListener("mousemove", (e) => {
        const label = el.dataset.label
        if (!label) return
        this.tooltip.textContent = label
        this.tooltip.classList.remove("hidden")
        this.tooltip.style.left = `${e.clientX + 12}px`
        this.tooltip.style.top = `${e.clientY - 28}px`
      })
      el.addEventListener("mouseleave", () => {
        this.tooltip.classList.add("hidden")
      })
    })
  }

  formatDate(date) {
    const y = date.getFullYear()
    const m = String(date.getMonth() + 1).padStart(2, '0')
    const d = String(date.getDate()).padStart(2, '0')
    return `${y}-${m}-${d}`
  }

  getColor(status, inRange) {
    if (!inRange) return 'bg-transparent'
    if (!status) return 'bg-gray-100'
    switch (status) {
      case 'completed': return 'bg-green-400'
      case 'declaring': return 'bg-blue-200'
      case 'pending': return 'bg-red-300'
      default: return 'bg-gray-100'
    }
  }

  statusLabel(status) {
    switch (status) {
      case 'completed': return '達成'
      case 'declaring': return '宣言中'
      case 'pending': return '未達成'
      default: return ''
    }
  }

  buildMonthLabels(weeks) {
    const labels = []
    let currentMonth = null
    let span = 0
    weeks.forEach(week => {
      const month = new Date(week[0].date).getMonth()
      if (month !== currentMonth) {
        if (currentMonth !== null) labels.push({ name: this.monthName(currentMonth), span })
        currentMonth = month
        span = 1
      } else {
        span++
      }
    })
    if (currentMonth !== null) labels.push({ name: this.monthName(currentMonth), span })
    return labels
  }

  monthName(month) {
    return ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'][month]
  }
}
