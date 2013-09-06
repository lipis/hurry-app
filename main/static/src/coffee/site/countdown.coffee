window.SECOND = 1000
window.MINUTE = 60 * SECOND
window.HOUR = 60 * MINUTE
window.DAY = 24 * HOUR
window.WEEK = 7 * DAY
window.MONTH = 30 * DAY
window.YEAR = 365.25 * DAY


window.init_countdown = () ->
  window.timestamp = parseInt($('.timestamp').data('timestamp')) * 1000
  LOG 'sf', timestamp
  if isNaN(timestamp)
    LOG 'sffd'
    window.goal = new Date()
  else
    window.goal = new Date(timestamp)

  ($ 'h2').html moment(goal).format('MMMM Do YYYY  @ HH:mm')

  repaint()

  setInterval ->
      repaint()
    , 83


window.repaint = () ->
  now = new Date()
  milliseconds = Math.abs(now - goal).toFixed(1)
  seconds = (milliseconds / SECOND).toFixed(2)
  minutes = (milliseconds / MINUTE).toFixed(3)
  hours = (milliseconds / HOUR).toFixed(4)
  days = (milliseconds / DAY).toFixed(5)
  weeks = (milliseconds / WEEK).toFixed(6)
  months = (milliseconds / MONTH).toFixed(7)
  years = (milliseconds / YEAR).toFixed(8)


  ($ '.int', '.years').text(add_commas(years.split('.')[0]))
  ($ '.dec', '.years').text(years.split('.')[1])

  ($ '.int', '.months').text(add_commas(months.split('.')[0]))
  ($ '.dec', '.months').text(months.split('.')[1])

  ($ '.int', '.weeks').text(add_commas(weeks.split('.')[0]))
  ($ '.dec', '.weeks').text(weeks.split('.')[1])

  ($ '.int', '.days').text(add_commas(days.split('.')[0]))
  ($ '.dec', '.days').text(days.split('.')[1])

  ($ '.int', '.hours').text(add_commas(hours.split('.')[0]))
  ($ '.dec', '.hours').text(hours.split('.')[1])

  ($ '.int', '.minutes').text(add_commas(minutes.split('.')[0]))
  ($ '.dec', '.minutes').text(minutes.split('.')[1])

  ($ '.int', '.seconds').text(add_commas(seconds.split('.')[0]))
  ($ '.dec', '.seconds').text(seconds.split('.')[1])

  ($ '.int', '.milliseconds').text(add_commas(milliseconds.split('.')[0]))
  ($ '.dec', '.milliseconds').text(milliseconds.split('.')[1])

add_commas = (n) ->
    return String(n).replace(/(\d)(?=(\d{3})+$)/g, '$1,')
