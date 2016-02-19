$('.edit-lyric-link').on 'click', (e) ->
  $('.edit-lyric').toggle()
  false

$('.update-lyric').on 'click', (e) ->
  $('form.edit_word').submit()
  false
