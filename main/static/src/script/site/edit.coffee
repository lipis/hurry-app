window.init_edit = ->
  window.timers = new Timers ($ '.timers')
  return if ($ '#edit').length == 0

  ($ 'input, select').change (e) ->
    update_counter e

  ($ 'input, select').keyup (e) ->
    update_counter e

  try
    ($ '#background').val new one.color(($ '#background').attr('value')).hex()
  catch
    ($ '#background').val '#ffffff'
  try
    ($ '#color').val new one.color(($ '#color').attr('value')).hex()
  catch
    ($ '#color').val '#000000'

  update_url()
  init_google_font()

window.update_counter = (event) ->
  group = $(event.currentTarget).data('group')
  if group
    ($ "##{group}-check").attr 'checked', true

  timers.set_timestamp calculate_timestamp ($ '#date').val(), ($ '#time').val()
  timers.set_title ($ '#title').val()
  update_url()
  set_theme()

window.calculate_timestamp = (date, time) ->
  now = moment()
  time = fix_time(time)
  date = fix_date(date)
  timestamp = moment()
  if date and time
    timestamp = moment "#{date} #{time}+00:00"
  else if date
    timestamp = moment "#{date} 00:00+00:00"
  else if time
    timestamp = moment "#{now.format('YYYY')}-#{now.format('MM')}-#{now.format('DD')} #{time}+00:00"

  if not timestamp.isValid()
    return false
  return timestamp.utc().unix()


window.update_url = ->
  url = ''
  if ($ '#date').val()
    date = fix_date ($ '#date').val()
    url += "/#{date}" if date

  if ($ '#time').val()
    time = fix_time ($ '#time').val()
    url += "/#{time}" if time

  if ($ '#title').val()
    url += '/' + encodeURIComponent ($ '#title').val()

  params = ''
  if ($ '#background').val() and ($ '#background').val() != '#ffffff'
    params += "b=#{($ '#background').val()}&"
  if ($ '#color').val() and ($ '#color').val() != '#000000'
    params += "c=#{($ '#color').val()}&"
  if ($ '#font').val() and ($ '#font').val() != 'Overlock'
    font = ($ '#font').val()
    font = font.replace(/\ /g, '+')
    params += "f=#{font}&"

  if url
    if params
      params = params.substr(0, params.length-1)
      params = params.replace(/#/g, '')
      url += "?#{params}"

    ($ '#url').show()
    url = location.origin + url
    embed_url = "#{url}#{if url.indexOf('?') == -1 then '?' else '&'}embed"
    ($ '#url').html "<a href='#{url}' class='alert-link'>#{url}</a>"
    ($ '.popout').attr 'href', embed_url
  else
    ($ '#url').hide()


window.set_theme = ->
  background = get_parameter_by_name('background') or get_parameter_by_name('b')
  if ($ '#background').length == 1
    background = ($ '#background').val()

  color = get_parameter_by_name('color') or get_parameter_by_name('c')
  if ($ '#color').length == 1
    color = ($ '#color').val()

  font = get_parameter_by_name('font') or get_parameter_by_name('f')  or 'Overlock'
  if ($ '#font').length == 1
    font = ($ '#font').val()
  background = new one.color(background)
  color = new one.color(color)

  ($ 'body').css 'background', background.hex() if background._red?
  ($ '.timers, h1, h2, h3, .lead, .help a, label').css 'color', color.hex() if color._red?

  if ($ '#google-font').length > 0
    ($ '#google-font').remove()
  if font
    ($ 'head').append("<link id='google-font' href='http://fonts.googleapis.com/css?family=#{font}' rel='stylesheet'>")
    ($ '.timers, .timers h1, .timers h2, .timers h3').css 'font-family', "#{font}, 'Helvetica Neue', Helvetica, Arial, sans-serif"


window.init_google_font = (data) ->
  return if not data?.items?
  ($ '#font').empty()
  for item in data.items
    option = $("<option></option>").attr('value', item.family).text item.family
    if item.family == ($ '#font').data('selected')
      option.attr 'selected', 'selected'
    ($ '#font').append option
