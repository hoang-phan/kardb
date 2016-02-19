$wordProcessedAts = $("[name='word[processed_at]']")
$wordDurations = $("[name='word[duration]']")
$editLyric = $('.edit-lyric')
$wordForms = $('form.edit_word')
$lyricShow = $('.lyric-show')
$scrollable = $lyricShow.find('.scrollable')
$words = $lyricShow.find('span')
$audio = $('audio')
prevProcessedAt = 0
prevDuration = 0

changeSubsequentProcessedAt = (changed, index) ->
  $.each $wordProcessedAts, (i, el) ->
    if i > index
      $el = $(el)
      $el.val(parseInt($el.val()) + changed)

updateSpan = (time) ->
  console.log(time)
  $.each $words, (i, el) ->
    $el = $(el)
    processed = parseInt($el.data('time'))
    duration = parseInt($el.data('duration'))
    $el.toggleClass('red', time >= processed)
  $lastRed = $lyricShow.find('span.red:last')
  marginTop = if $lastRed.length > 0 then parseInt($lastRed.data('pos')) * 52 else 0
  $scrollable.css('margin-top', '-' + marginTop + 'px')

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

$audio.on 'timeupdate', (e) ->
  updateSpan($audio[0].currentTime * 1000)
