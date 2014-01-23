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

  $(window).on "deviceorientation", (e) ->
    window.accelerationValues.push
      x: e.originalEvent.alpha
      y: e.originalEvent.beta
      z: e.originalEvent.gamma
    window.accelerationValues = window.accelerationValues.slice -100
    updateGraph()

  drawGraph()
