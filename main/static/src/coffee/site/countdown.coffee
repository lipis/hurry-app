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
  set_theme()
  window.timestamp = parseInt($('.timers').data('timestamp')) * 1000
  if isNaN(timestamp)
    window.goal = moment()
  else
    window.goal = moment(timestamp)

  ($ '.date').text goal.utc().format('MMMM Do YYYY')
  ($ '.utc', '.time').html '<small>UTC</small> ' + goal.utc().format('HH:mm')
  ($ '.local', '.time').html '<small>LOCAL</small> ' + goal.zone(moment().zone()).format('HH:mm')

  request_repaint()

  for unit in UNITS
    ($ '.units').append """
        <li class="#{unit}">
          <div class="int"></div>
          <div class="dec"></div>
          <div class="caption">#{unit}</div>
        </li>
      """

  ($ '.help-header', '.help').click () ->
    if ($ this).parent().hasClass('collapsed')
      ($ this).parent().removeClass('collapsed')
      ($ 'span', this).addClass('icon-rotate-180')
    else
      ($ this).parent().addClass('collapsed')
      ($ 'span', this).removeClass('icon-rotate-180')


window.request_repaint = ->
  repaint()
  requestAnimationFrame request_repaint

window.repaint = ->
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

  base = get_parameter_by_name('base') or 10
  try
    base = Math.max(2, Math.min(16, parseInt(base)))
  catch
    base = 10

  for unit in UNITS
    if base == 10
      ($ '.int', ".#{unit}").text add_commas(values[unit].split('.')[0])
    else
      ($ '.int', ".#{unit}").text parseInt(values[unit].split('.')[0]).toString(base)

    ($ '.dec', ".#{unit}").text values[unit].split('.')[1]

    ($ ".#{unit}").css('opacity', Math.max(0.1, Math.min(1, parseFloat(values[unit]))))

window.set_theme = ->
  background = get_parameter_by_name('background') or get_parameter_by_name('b')
  color = get_parameter_by_name('color') or get_parameter_by_name('c')
  font = get_parameter_by_name('font') or get_parameter_by_name('f')

  background = new one.color(background)
  color = new one.color(color)

  ($ 'body').css 'background', background.hex() if background._red?
  ($ 'body, h1, h2, h3').css 'color', color.hex() if color._red?

  if font
    ($ 'head').append("<link href='http://fonts.googleapis.com/css?family=#{font}' rel='stylesheet' type='text/css'>")
    ($ '.timers, .timers h1, .timers h2, .timers h3').css 'font-family', font

