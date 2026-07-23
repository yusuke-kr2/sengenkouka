import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { data: Object }

  connect() {
    this.render()
  }

  render() {
    const data = this.dataValue
    const today = new Date()
    const startDate = new Date(today)
    startDate.setDate(startDate.getDate() - 364)

    // 日曜始まりに調整
    const dayOfWeek = startDate.getDay()
    startDate.setDate(startDate.getDate() - dayOfWeek)

    const weeks = []
    let current = new Date(startDate)

    while (current <= today) {
      const week = []
      for (let i = 0; i < 7; i++) {
        const dateStr = this.formatDate(current)
        const isInRange = current >= new Date(today.getFullYear(), today.getMonth(), today.getDate() - 364) && current <= today
        week.push({ date: dateStr, status: data[dateStr] || null, inRange: isInRange })
        current.setDate(current.getDate() + 1)
      }
      weeks.push(week)
    }

    // 月ラベル
    const monthLabels = this.buildMonthLabels(weeks)

    let html = '<div class="overflow-x-auto">'
    html += '<div class="inline-flex flex-col gap-0.5">'

    // 月ラベル行
    html += '<div class="flex gap-0.5 mb-1 ml-0">'
    monthLabels.forEach(label => {
      html += `<span class="text-xs text-gray-400" style="width:${label.span * 13}px">${label.name}</span>`
    })
    html += '</div>'

    // ヒートマップグリッド
    html += '<div class="flex gap-0.5">'
    weeks.forEach(week => {
      html += '<div class="flex flex-col gap-0.5">'
      week.forEach(day => {
        const colorClass = this.getColor(day.status, day.inRange)
        const tooltip = day.inRange ? `${day.date}${day.status ? ` (${this.statusLabel(day.status)})` : ''}` : ''
        html += `<div class="w-3 h-3 rounded-sm ${colorClass}" title="${tooltip}"></div>`
      })
      html += '</div>'
    })
    html += '</div>'

    // 凡例
    html += '<div class="flex items-center gap-3 mt-2">'
    html += '<span class="text-xs text-gray-400">少</span>'
    html += '<div class="w-3 h-3 rounded-sm bg-gray-100"></div>'
    html += '<div class="w-3 h-3 rounded-sm bg-blue-200"></div>'
    html += '<div class="w-3 h-3 rounded-sm bg-green-400"></div>'
    html += '<div class="w-3 h-3 rounded-sm bg-red-300"></div>'
    html += '<span class="text-xs text-gray-400">宣言中 / 達成 / 未達成</span>'
    html += '</div>'

    html += '</div></div>'

    this.element.innerHTML = html
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
      const firstDay = new Date(week[0].date)
      const month = firstDay.getMonth()
      if (month !== currentMonth) {
        if (currentMonth !== null) {
          labels.push({ name: this.monthName(currentMonth), span })
        }
        currentMonth = month
        span = 1
      } else {
        span++
      }
    })
    if (currentMonth !== null) {
      labels.push({ name: this.monthName(currentMonth), span })
    }
    return labels
  }

  monthName(month) {
    return ['1月','2月','3月','4月','5月','6月','7月','8月','9月','10月','11月','12月'][month]
  }
}
