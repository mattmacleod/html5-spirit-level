#=require "lib/jquery"
#=require "lib/flot"

$ ->
  window.accelerationValues = []

  drawGraph = ->
    $.plot $("#graph"), [{data: []}], {}

  updateGraph = ->
    i = 0
    points = 
      x:[]
      y:[]
      z:[]

    window.accelerationValues.forEach (e) ->
      points.x.push [i,e.x]
      points.y.push [i,e.y]
      points.z.push [i,e.z]
      i++

    plot = $("#graph").data "plot"
    plot.setData [{data: points.x}, {data: points.y}, {data: points.z}]
    plot.setupGrid()
    plot.draw()


  sphere = $('#sphere')
  updateSphere = ->
    v = window.accelerationValues.slice(-1)[0]
    x = v.x
    y = v.y
    z = v.z
    sphere.css
      "-webkit-transform": "rotateX(#{x}deg) rotateY(#{y}deg) rotateZ(#{z}deg)"

  $(window).on "deviceorientation", (e) ->
    window.accelerationValues.push
      z: e.originalEvent.alpha
      x: e.originalEvent.beta
      y: e.originalEvent.gamma
    window.accelerationValues = window.accelerationValues.slice -100
    updateGraph()
    updateSphere()


  drawGraph()
