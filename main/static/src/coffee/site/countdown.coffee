window.SECOND = 1000
window.MINUTE = 60 * SECOND
window.HOUR = 60 * MINUTE
window.DAY = 24 * HOUR
window.WEEK = 7 * DAY
window.MONTH = 30 * DAY
window.YEAR = 365.25 * DAY


window.init_countdown = () ->
  window.timestamp = parseInt($('.timers').data('timestamp')) * 1000
  if isNaN(timestamp)
    window.goal = moment()
  else
    window.goal = moment(timestamp)

  ($ '.local').html goal.zone(moment().zone()).format('MMMM Do YYYY')
  ($ '.utc').html '<small>UTC</small> ' + goal.utc().format('HH:mm') + ' <small>LOCAL</small> ' + goal.zone(moment().zone()).format('HH:mm')

  repaint()

  setInterval ->
      repaint()
    , 83

  ($ 'h4', '.help').click () ->
    if ($ this).parent().hasClass('collapsed')
      ($ this).parent().removeClass('collapsed')
      ($ 'span', this).addClass('icon-rotate-180')
    else
      ($ this).parent().addClass('collapsed')
      ($ 'span', this).removeClass('icon-rotate-180')



window.repaint = () ->
  now = moment.utc()
  milliseconds = Math.abs(now - goal).toFixed(1)
  seconds = (milliseconds / SECOND).toFixed(2)
  minutes = (milliseconds / MINUTE).toFixed(3)
  hours = (milliseconds / HOUR).toFixed(4)
  days = (milliseconds / DAY).toFixed(5)
  weeks = (milliseconds / WEEK).toFixed(6)
  months = (milliseconds / MONTH).toFixed(7)
  years = (milliseconds / YEAR).toFixed(8)


  ($ '.int', '.years').text add_commas(years.split('.')[0])
  ($ 'span', '.years').text years.split('.')[1]

  ($ '.int', '.months').text add_commas(months.split('.')[0])
  ($ 'span', '.months').text months.split('.')[1]

  ($ '.int', '.weeks').text add_commas(weeks.split('.')[0])
  ($ 'span', '.weeks').text weeks.split('.')[1]

  ($ '.int', '.days').text add_commas(days.split('.')[0])
  ($ 'span', '.days').text days.split('.')[1]

  ($ '.int', '.hours').text add_commas(hours.split('.')[0])
  ($ 'span', '.hours').text hours.split('.')[1]

  ($ '.int', '.minutes').text add_commas(minutes.split('.')[0])
  ($ 'span', '.minutes').text minutes.split('.')[1]

  ($ '.int', '.seconds').text add_commas(seconds.split('.')[0])
  ($ 'span', '.seconds').text seconds.split('.')[1]

  ($ '.int', '.milliseconds').text add_commas(milliseconds.split('.')[0])
  ($ 'span', '.milliseconds').text milliseconds.split('.')[1]

add_commas = (n) ->
    return String(n).replace(/(\d)(?=(\d{3})+$)/g, '$1,')
