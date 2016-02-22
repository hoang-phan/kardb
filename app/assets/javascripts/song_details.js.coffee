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
audioIndex = 0
prevProcessedAt = 0
prevDuration = 0

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
      $el.closest('form.edit_word').attr('dirty', 1)

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

$('.edit-lyric-link').on 'click', (e) ->
  $editLyric.toggle()
  false

$toggleAudio.on 'click', (e) ->
  if $beatContainer.is(':visible')
    $beatContainer.hide()
    $songContainer.show()
    $toggleAudio.text('Beat')
    audioIndex = 1
  else
    $songContainer.hide()
    $beatContainer.show()
    $toggleAudio.text('Original song')
    audioIndex = 0
  false

$('.update-lyric').on 'click', (e) ->
  $('form.edit_word[dirty=1]').submit()
  false

$wordProcessedAts.on 'focusin', (e) ->
  prevProcessedAt = parseInt($(this).val())

$wordDurations.on 'focusin', (e) ->
  prevDuration = parseInt($(this).val())

$wordProcessedAts.on 'change', (e) ->
  $this = $(this)
  $this.closest('form').attr('dirty', 1)
  current = parseInt($this.val())
  $span = $lyricShow.find("[data-time=#{prevProcessedAt}]")
  $span.attr('data-time', current)
  $span.data('time', current)
  changeSubsequentProcessedAt(current - prevProcessedAt, $wordProcessedAts.index(@))
  prevProcessedAt = current

$wordDurations.on 'change', (e) ->
  $this = $(this)
  $this.closest('form').attr('dirty', 1)
  current = parseInt($this.val())
  $span = $lyricShow.find("[data-time=#{prevProcessedAt}]")
  $span.attr('data-duration', current)
  $span.data('duration', current)
  changeSubsequentProcessedAt(current - prevDuration, $wordDurations.index(@))
  prevDuration = current

$audio.on 'timeupdate', (e) ->
  updateSpan($audio[audioIndex].currentTime * 1000)
