$wordProcessedAts = $("[name='word[processed_at]']")
$wordDurations = $("[name='word[duration]']")
$editLyric = $('.edit-lyric')
$wordForms = $('form.edit_word')
prevProcessedAt = 0
prevDuration = 0

changeSubsequentProcessedAt = (changed, index) ->
  $.each $wordProcessedAts, (i, el) ->
    if i > index
      $el = $(el)
      $el.val(parseInt($el.val()) + changed)

$('.edit-lyric-link').on 'click', (e) ->
  $editLyric.toggle()
  false

$('.update-lyric').on 'click', (e) ->
  $wordForms.submit()
  false

$wordProcessedAts.on 'focusin', (e) ->
  prevProcessedAt = parseInt($(this).val())

$wordDurations.on 'focusin', (e) ->
  prevDuration = parseInt($(this).val())

$wordProcessedAts.on 'change', (e) ->
  current = parseInt($(this).val())
  changeSubsequentProcessedAt(current - prevProcessedAt, $wordProcessedAts.index(@))
  prevProcessedAt = current

$wordDurations.on 'change', (e) ->
  current = parseInt($(this).val())
  changeSubsequentProcessedAt(current - prevDuration, $wordDurations.index(@))
  prevDuration = current
