#=require "lib/jquery"

$ ->

  window.app =
    zeroColor: 'green'
    zeroTransitionTime: 15
  
  timeAtZero = 0

  resizeCanvas = ->
    window.devicePixelRatio ||= 1
    canvas.width = window.outerWidth * window.devicePixelRatio              
    canvas.height = window.outerHeight * window.devicePixelRatio              

    window.app.centerX = canvas.width / 2
    window.app.centerY = canvas.height / 2
    window.app.radius  = Math.min(canvas.width, canvas.height) * 0.33
    window.app.isHorizontal = Math.abs(window.orientation) == 90

    context.font = "100 100pt 'Helvetica Neue'"
    context.textAlign = "center"
    context.textBaseline = "middle"



  drawCircles = (x, y, z, angle) ->

    # Fix angles if we have rotated the device
    if window.app.isHorizontal
      xprime = y
      y = x
      x = xprime
      if window.orientation == 90
        x = -x
        y = -y

    # If we are within 1 degree, snap to zero
    if angle==0
      if timeAtZero < 0
        timeAtZero = 0
      else
        timeAtZero++
        timeAtZero = Math.min(timeAtZero, window.app.zeroTransitionTime)
      x1 = x2 = y1 = y2 = 0

    else
      if timeAtZero > window.app.zeroTransitionTime
        timeAtZero = window.app.zeroTransitionTime
      else
        timeAtZero--
        timeAtZero = Math.max(timeAtZero, 0)

      x1 = (y/30) * canvas.width
      x2 = x1 * -1

      y1 = (x/70) * canvas.height
      y2 = y1 * -1

    # Get local copies of canvas config params
    centerX = window.app.centerX
    centerY = window.app.centerY
    radius  = window.app.radius

    # We will change some operations if we're at square
    isZero = (x1 == x2 == y1 == y2 == angle == 0)

    # Clear
    context.globalCompositeOperation = 'source-over'
    context.fillStyle = if isZero then window.app.zeroColor else 'black'
    context.fillRect 0, 0, canvas.width, canvas.height
    unless isZero
      context.globalCompositeOperation = 'difference' 

    # Calculate positions
    firstCircleCenterX =  centerX + x1
    firstCircleCenterY =  centerY + y1
    secondCircleCenterX = centerX + x2
    secondCircleCenterY = centerY + y2

    # Circle 1
    context.beginPath()
    context.arc firstCircleCenterX, firstCircleCenterY, radius+5, 0, 2 * Math.PI, false
    context.fillStyle = 'white';
    context.fill()
    context.closePath()

    # Circle 2
    context.beginPath()
    context.arc secondCircleCenterX, secondCircleCenterY, radius, 0, 2 * Math.PI, false
    context.fillStyle = if isZero then window.app.zeroColor else "white"
    context.fill()
    context.closePath()

    # Text
    context.fillStyle = 'white'
    contextRotationAngle = Math.atan(y1 / x1) + (Math.PI / (if x1<0 then 2 else -2))
    context.translate (canvas.width/2), (canvas.height/2)
    context.rotate contextRotationAngle
    context.translate (canvas.width/-2), (canvas.height/-2)
    context.fillText "#{ angle }°", centerX, centerY
    context.translate (canvas.width/2), (canvas.height/2)
    context.rotate -1 * contextRotationAngle
    context.translate (canvas.width/-2), (canvas.height/-2)

    # Add zero colour
    if timeAtZero > 0
      progressToZero = timeAtZero / window.app.zeroTransitionTime
      additionalColor = "rgb(0,#{ Math.round(progressToZero * 75) },0)"
      context.globalCompositeOperation = 'lighter'
      context.fillStyle = additionalColor
      context.fillRect 0, 0, canvas.width, canvas.height


  $(window).on "deviceorientation", (e) ->
    x = e.originalEvent.beta
    y = e.originalEvent.gamma
    z = e.originalEvent.alpha

    # Calculate the angle from flat, which we can use later to draw different
    # compass representations which depend on the device angle.
    angleFromFlat = Math.round(Math.sqrt Math.pow(y,2) + Math.pow(x,2))
    drawCircles x, y, z, angleFromFlat

  if window.orientation != undefined
    $("body").append "<canvas id='canvas'/>"
    canvas  = $('#canvas')[0]
    context = canvas.getContext('2d')
    resizeCanvas()
    $(window).on "resize orientationchange", resizeCanvas
    $("body").on "touchstart", -> false

  else
    $("body").append "<div id='unsupported'>This device does not support orientation events. Sorry!</div>"
