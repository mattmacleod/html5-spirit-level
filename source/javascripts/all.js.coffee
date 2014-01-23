#=require "lib/jquery"

$ ->

  window.appConfig =
    snapRadius: 4
    squareColor: 'green'

  canvas  = $('#canvas')[0]
  canvas.width = window.innerWidth
  canvas.height = window.innerHeight

  context = canvas.getContext('2d')
  width = canvas.width
  height = canvas.height
  centerX = width / 2
  centerY = height / 2
  radius  = Math.min(width, height) * 0.33

  context.font = "100 200pt 'Helvetica Neue'"
  context.textAlign = "center"
  context.textBaseline = "middle"

  drawCanvas = (x1,y1,x2,y2,angle) ->

    # We will change some operations if we're at square
    isZero = (x1 == x2 == y1 == y2 == 0)

    # Clear
    context.globalCompositeOperation = 'source-over'
    context.fillStyle = if isZero then window.appConfig.squareColor else 'black'
    context.fillRect 0, 0, width, height
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
    context.fillStyle = if isZero then window.appConfig.squareColor else 'white'
    context.fill()
    context.closePath()

    # Text
    context.fillStyle = 'white'
    context.fillText "#{ angle }°", centerX, centerY

  $(window).on "deviceorientation", (e) ->
    x = e.originalEvent.beta
    y = e.originalEvent.gamma
    z = e.originalEvent.alpha

    x1 = (y/90) * width
    x2 = x1 * -1

    y1 = (x/180) * height
    y2 = y1 * -1

    # Calculate the angle from square
    angle = Math.round(Math.sqrt Math.pow(y,2) + Math.pow(x,2))

    # If we are within tolerance, snap to zero
    if Math.abs(x1) < window.appConfig.snapRadius && Math.abs(y1) < window.appConfig.snapRadius
      x1 = x2 = y1 = y2 = 0
      angle = 0


    drawCanvas(x1,y1,x2,y2, angle)
