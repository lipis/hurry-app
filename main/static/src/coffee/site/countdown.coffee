window.SECOND = 1000
window.MINUTE = 60 * SECOND
window.HOUR = 60 * MINUTE
window.DAY = 24 * HOUR
window.WEEK = 7 * DAY
window.MONTH = 30 * DAY
window.YEAR = 365.25 * DAY

window.UNITS = [
    'seconds'
    'minutes'
    'hours'
    'days'
    'weeks'
    'months'
    'years'
  ]

window.init_countdown = () ->
  window.timestamp = parseInt($('.timers').data('timestamp')) * 1000
  if isNaN(timestamp)
    window.goal = moment()
  else
    window.goal = moment(timestamp)

  ($ '.date').html goal.zone(moment().zone()).format('MMMM Do YYYY')
  ($ '.time').html '<small>UTC</small> ' + goal.utc().format('HH:mm') + ' &nbsp; <small>LOCAL</small> ' + goal.zone(moment().zone()).format('HH:mm')

  repaint()

  request_repaint = ->
    repaint()
    requestAnimationFrame request_repaint

  request_repaint()

  requestAnimationFrame

  for unit in UNITS
    ($ '.units').append """
        <li class="#{unit}">
          <div class="int"></div>
          <div class="caption">#{unit}</div>
          <div class="dec"></div>
        </li>
      """

  ($ '.help-header', '.help').click () ->
    if ($ this).parent().hasClass('collapsed')
      ($ this).parent().removeClass('collapsed')
      ($ 'span', this).addClass('icon-rotate-180')
    else
      ($ this).parent().addClass('collapsed')
      ($ 'span', this).removeClass('icon-rotate-180')


window.repaint = () ->
  now = moment.utc()
  milliseconds = Math.abs(now - goal).toFixed(1)
  values =
    seconds: (milliseconds / SECOND).toFixed(2)
    minutes: (milliseconds / MINUTE).toFixed(3)
    hours: (milliseconds / HOUR).toFixed(4)
    days: (milliseconds / DAY).toFixed(5)
    weeks: (milliseconds / WEEK).toFixed(6)
    months: (milliseconds / MONTH).toFixed(7)
    years: (milliseconds / YEAR).toFixed(8)

  for unit in UNITS
    ($ '.int', ".#{unit}").text add_commas(values[unit].split('.')[0])
    ($ '.dec', ".#{unit}").text values[unit].split('.')[1]
    ($ ".#{unit}").css('opacity', values[unit])
