window.LOG = () ->
  console?.log?(arguments...)

window.init_loading_button = () ->
  $('body').on 'click', '.btn-loading', ->
    $(this).button('loading')

window.add_commas = (n) ->
  return String(n).replace(/(\d)(?=(\d{3})+$)/g, '$1,')

window.requestAnimationFrame = window.requestAnimationFrame or window.mozRequestAnimationFrame or window.webkitRequestAnimationFrame or window.msRequestAnimationFrame
