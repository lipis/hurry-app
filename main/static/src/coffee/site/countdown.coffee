window.init_countdown = () ->
  window.timers = new Timers ($ '.timers')
  init_edit()
  set_theme()

  ($ 'body').on 'click', '.popout', (e) ->
    e.preventDefault()
    e.stopPropagation()
    width = 400
    height = 480
    window.open ($ this).attr('href'), 'hurry-app', """
        width=#{width},
        height=#{height},
        left=#{screen.width - width},
        top=0,
        resizable=yes,
        scrollbars=no,
        toolbar=no,
        menubar=no,
        location=no,
        directories=no,
        status=yes
      """

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

class window.Timers
  constructor: (@host) ->
    @init_template()
    @set_title @host.data 'title'

    date = @host.data('date') or undefined
    time = @host.data('time') or undefined
    @set_timestamp calculate_timestamp date, time
    request_repaint?()

  init_template : ->
    @host.empty()
    @host.append """
        <h1></h1>
        <h2></h2>
        <h3></h3>
        <ul class="list-unstyled"></ul>
      """
    for unit in UNITS
      ($ 'ul', @host).append """
          <li class="#{unit}">
            <div class="int"></div>
            <div class="dec"></div>
            <div class="caption"><span class="icon-arrow-up"></span> #{unit}</div>
          </li>
        """

  set_title: (title) ->
    ($ 'h1', @host).remove()
    if title
      @host.prepend ($ '<h1>').text title

  set_timestamp: (timestamp) ->
    @goal = moment.unix(timestamp)
    window.goal = @goal
    ($ 'h2').text @goal.utc().format 'dddd, MMMM Do YYYY'
    utc = '<small>UTC</small> ' + @goal.utc().format 'HH:mm'
    local = '<small>LOCAL</small> ' + @goal.zone(moment().zone()).format 'HH:mm'
    ($ 'h3').html "<span>#{utc}</span> <span>#{local}</span>"


window.repaint = ->
  return if not goal
  now = moment.utc()
  if now - goal > 0
    ($ '.icon-arrow-up', '.caption').removeClass('icon-rotate-180')
  else
    ($ '.icon-arrow-up', '.caption').addClass('icon-rotate-180')

  milliseconds = Math.abs(now - goal).toFixed 1
  values =
    seconds: (milliseconds / SECOND).toFixed 2
    minutes: (milliseconds / MINUTE).toFixed 3
    hours: (milliseconds / HOUR).toFixed 4
    days: (milliseconds / DAY).toFixed 5
    weeks: (milliseconds / WEEK).toFixed 6
    months: (milliseconds / MONTH).toFixed 7
    years: (milliseconds / YEAR).toFixed 8

  for unit in UNITS
    ($ '.int', ".#{unit}").text add_commas(values[unit].split('.')[0])
    ($ '.dec', ".#{unit}").text values[unit].split('.')[1]
    ($ ".#{unit}").css('opacity', Math.max(0.1, Math.min(1, parseFloat(values[unit]))))

  digits = Math.floor(Math.log(values.seconds)/Math.LN10)
  percent = 50 + 15 * (digits / 10.0)
  ($ '.int').css 'right', "#{100 - percent}%"
  ($ '.dec').css 'left', "#{percent}%"
  ($ '.caption').css 'left', "#{percent}%"


window.request_repaint = ->
  repaint()
  requestAnimationFrame request_repaint
