#=require "lib/jquery"

$ ->

  window.app =
    zeroColor: 'green'

  canvas  = $('#canvas')[0]
  context = canvas.getContext('2d')

  resizeCanvas = ->
    canvas.width  = window.innerWidth
    canvas.height = window.innerHeight

    window.app.centerX = canvas.width / 2
    window.app.centerY = canvas.height / 2
    window.app.radius  = Math.min(canvas.width, canvas.height) * 0.33

    context.font = "100 200pt 'Helvetica Neue'"
    context.textAlign = "center"
    context.textBaseline = "middle"

  resizeCanvas()

  drawCanvas = (x1,y1,x2,y2,angle) ->

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
    firstCircleCenterX = centerX + x1
    firstCircleCenterY = centerY + y1
    secondCircleCenterX = centerX + x2
    secondCircleCenterY = centerY + y2

    # Circle 1
    context.beginPath()
    context.arc firstCircleCenterX, firstCircleCenterY, radius+10, 0, 2 * Math.PI, false
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
    console.log contextRotationAngle
    context.translate (canvas.width/2), (canvas.height/2)
    context.rotate contextRotationAngle
    context.translate (canvas.width/-2), (canvas.height/-2)
    context.fillText "#{ angle }°", centerX, centerY
    context.translate (canvas.width/2), (canvas.height/2)
    context.rotate -1 * contextRotationAngle
    context.translate (canvas.width/-2), (canvas.height/-2)

  $(window).on "deviceorientation", (e) ->
    x = e.originalEvent.beta
    y = e.originalEvent.gamma
    z = e.originalEvent.alpha

    x1 = (y/30) * canvas.width
    x2 = x1 * -1

    y1 = (x/70) * canvas.height
    y2 = y1 * -1

    # Calculate the angle from square
    angle = Math.round(Math.sqrt Math.pow(y,2) + Math.pow(x,2))

    # If we are within 1 degree, snap to zero
    if angle==0
      x1 = x2 = y1 = y2 = 0

    drawCanvas(x1,y1,x2,y2, angle)

  $(window).on "resize", resizeCanvas
