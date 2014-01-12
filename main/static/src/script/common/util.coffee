window.LOG = ->
  console?.log? arguments...


window.init_common = ->
  init_loading_button()
  init_time()


window.init_loading_button = ->
  ($ 'body').on 'click', '.btn-loading', ->
    ($ this).button 'loading'


window.init_time = ->
  if ($ 'time').length > 0
    recalculate = ->
      ($ 'time[datetime]').each ->
        date = moment.utc ($ this).attr 'datetime'
        diff = moment().diff date , 'days'
        if diff > 25
          ($ this).text date.local().format 'YYYY-MM-DD'
        else
          ($ this).text date.fromNow()
        ($ this).attr 'title', date.local().format 'dddd, MMMM Do YYYY, HH:mm:ss Z'
      setTimeout arguments.callee, 1000 * 45
    recalculate()


window.clear_notifications = ->
  ($ '#notifications').empty()


window.show_notification = (message, category='warning') ->
  clear_notifications()
  return if not message

  ($ '#notifications').append """
      <div class="alert alert-dismissable alert-#{category}">
        <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
        #{message}
      </div>
    """


window.add_commas = (n) ->
  return String(n).replace(/(\d)(?=(\d{3})+$)/g, '$1,')


window.get_parameter_by_name = (name) ->
  name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]")
  regex = new RegExp("[\\?&]" + name + "=([^&#]*)")
  results = regex.exec(location.search)
  (if not results? then "" else decodeURIComponent(results[1].replace(/\+/g, " ")))


window.requestAnimationFrame = window.requestAnimationFrame or window.mozRequestAnimationFrame or window.webkitRequestAnimationFrame or window.msRequestAnimationFrame


window.zero = (number) ->
  if number < 10
    return '0' + number
  return number


window.fix_time = (time) ->
  if "#{time}".indexOf(':') == -1
    hour = parseInt(time)
    minute = 0
  else
    parts = time.split(':')
    hour = parseInt(parts[0])
    minute = parseInt(parts[1]) or 0

  hour = Math.max(0, Math.min(23, parseInt(hour)))
  minute = Math.max(0, Math.min(59, parseInt(minute)))

  if isNaN(hour) or isNaN(minute)
    return false

  return "#{zero hour}:#{zero minute}"


window.fix_date = (date) ->
  return false if not date

  parts = date.split('-')

  year = Math.max(100, Math.min(9999, parseInt(parts[0])))
  month = parseInt(parts[1]) or 1
  day = parseInt(parts[2]) or 1

  timestamp = moment "#{year}-#{month}-#{day}", "YYYY-MM-DD"
  if timestamp.isValid()
    return timestamp.format('YYYY-MM-DD')
  return false
