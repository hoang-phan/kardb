$wordProcessedAts = $("[name='word[processed_at]']")
$wordDurations = $("[name='word[duration]']")
$editLyric = $('.edit-lyric')
$lyricShow = $('.lyric-show')
$toggleAudio = $('.toggle-audio')
$beatContainer = $('.beat-container')
$songContainer = $('.song-container')
$scrollable = $lyricShow.find('.scrollable')
$words = $lyricShow.find('span')
$audio = $('audio')
$cursor = $('.cursor')
$viewport = $('.viewport')
$imgs = $viewport.find('img')
audioIndex = 0
prevProcessedAt = 0
prevDuration = 0
initTopOffset = []

$('audio:first').on 'loadeddata', (e) ->
  $.each $('p.word-form'), (i, el) ->
    $el = $(el)
    $el.css('top', "#{parseInt($el.find('[name="word[processed_at]"]').val()) / $audio[0].duration / 10}%")

changeSubsequentProcessedAt = (changed, index) ->
  $.each $wordProcessedAts, (i, el) ->
    if i > index
      $el = $(el)
      prev = parseInt($el.val())
      current = prev + changed
      $span = $lyricShow.find("[data-time=#{prev}]")
      $span.attr('data-time', current)
      $span.data('time', current)
      $el.val(current)
      $el.closest('p.word-form').css('top', "#{current / $audio[audioIndex].duration / 10}%")

updateSpan = (time) ->
  $cursor.css('top', "#{time / $audio[audioIndex].duration / 10}%")
  $.each $words, (i, el) ->
    $el = $(el)
    processed = parseInt($el.data('time'))
    duration = parseInt($el.data('duration'))
    $el.toggleClass('red', time >= processed)
  $lastRed = $lyricShow.find('span.red:last')
  marginTop = if $lastRed.length > 0 then parseInt($lastRed.data('pos')) * 52 else 0
  $scrollable.css('margin-top', '-' + marginTop + 'px')

$('p.word-form').draggable
  axis: 'y'
  start: (e, ui) ->
    prevProcessedAt = parseInt($(this).find('[name="word[processed_at]"]').val())
  stop: (e, ui) ->
    $this = $(this)
    top = $this.position().top
    $wordProcessed = $this.find('[name="word[processed_at]"]')
    $wordProcessed.val(current = Math.round(top * $audio[audioIndex].duration / 2500) * 50)
    $this.css('top', "#{current / $audio[audioIndex].duration / 10}%")
    unless e.shiftKey
      changeSubsequentProcessedAt(current - prevProcessedAt, $wordProcessedAts.index($wordProcessed))

$('.edit-lyric-link').on 'click', (e) ->
  $editLyric.toggle()
  false

$toggleAudio.on 'click', (e) ->
  if $beatContainer.is(':visible')
    $beatContainer.hide()
    $songContainer.css('display', 'inline-block')
    $toggleAudio.text('Beat')
    audioIndex = 1
  else
    $songContainer.hide()
    $beatContainer.show()
    $toggleAudio.text('Original song')
    audioIndex = 0
  false

$('.update-lyric').on 'click', (e) ->
  $('form.edit_word').submit()
  false

$wordProcessedAts.on 'focusin', (e) ->
  prevProcessedAt = parseInt($(this).val())

$wordDurations.on 'focusin', (e) ->
  prevDuration = parseInt($(this).val())

$wordProcessedAts.on 'change', (e) ->
  $this = $(this)
  current = parseInt($this.val())
  $this.closest('p.word-form').css('top', "#{current / $audio[audioIndex].duration / 10}%")
  $span = $lyricShow.find("[data-time=#{prevProcessedAt}]")
  $span.attr('data-time', current)
  $span.data('time', current)
  changeSubsequentProcessedAt(current - prevProcessedAt, $wordProcessedAts.index(@))
  prevProcessedAt = current

$wordDurations.on 'change', (e) ->
  $this = $(this)
  current = parseInt($this.val())
  $span = $lyricShow.find("[data-time=#{prevProcessedAt}]")
  $span.attr('data-duration', current)
  $span.data('duration', current)
  changeSubsequentProcessedAt(current - prevDuration, $wordDurations.index(@))
  prevDuration = current

$audio.on 'timeupdate', (e) ->
  updateSpan($audio[audioIndex].currentTime * 1000)

$imgs.on 'click', (e) ->
  y = e.offsetY
  $cursor.css('top', y + 'px')
  $audio[audioIndex].currentTime = y * $audio[audioIndex].duration / 50000

$lyricShow.on 'click', (e) ->
  $viewport.animate
      scrollTop: $cursor.position().top
    ,1000
