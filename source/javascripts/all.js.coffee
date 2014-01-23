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

  samples = 0

  $(window).on "devicemotion", (e) ->
    samples++
    window.accelerationValues.push
      x: e.originalEvent.accelerationIncludingGravity.x - e.originalEvent.acceleration.x
      y: e.originalEvent.accelerationIncludingGravity.y - e.originalEvent.acceleration.y
      z: e.originalEvent.accelerationIncludingGravity.z - e.originalEvent.acceleration.z
    window.accelerationValues = window.accelerationValues.slice -100
    updateGraph()

  drawGraph()

  window.setInterval ->
    $("#samplecounter").text "Samples: #{ samples }"
    samples = 0
  , 1000
