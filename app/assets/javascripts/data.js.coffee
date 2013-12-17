$ ->
  width = 1200
  height = 800

  projection = d3.geo.orthographic().scale(400).translate([width / 2, height / 2]).clipAngle(90)

  path = d3.geo.path().projection(projection)

  path.pointRadius(2)

  svg = d3.select("#map").append("svg").attr("width", width).attr("height", height)

  m0 = null
  o0 = null

  drag = d3.behavior.drag().on("dragstart", ->
    d3.event.sourceEvent.stopPropagation
    proj = projection.rotate()
    m0 = [d3.event.sourceEvent.pageX, d3.event.sourceEvent.pageY]
    o0 = [-proj[0],-proj[1]]
  ).on("drag", ->
    if m0
      m1 = [d3.event.sourceEvent.pageX, d3.event.sourceEvent.pageY]
      o1 = [o0[0] + (m0[0] - m1[0]) / 4, o0[1] + (m1[1] - m0[1]) / 4]
      projection.rotate([-o1[0], -o1[1]])
      d3.selectAll("path").attr("d", path)
  )

  scale0 = projection.scale()

  zoom = d3.behavior.zoom().scale(projection.scale()).on("zoom", ->
    scale = d3.event.scale
    projection.scale(scale)
    backgroundCircle.attr('r', scale)
    path.pointRadius(2 * scale / scale0)
    d3.selectAll("path").attr("d", path)
  )

  backgroundCircle = svg.append("circle").attr("cx", width / 2).attr("cy", height / 2).attr("r", projection.scale()).attr("class", "globe").call(drag).call(zoom)

  d3.json "data/map_json.json", (error, world) ->
    svg.append("path").datum(topojson.feature(world, world.objects.land)).attr("class", "land").attr("d", path).call(drag).call(zoom)
    svg.append("path").datum(topojson.mesh(world, world.objects.countries, (a, b) ->
      a isnt b
    )).attr("class", "boundary").attr("d", path)

  d3.json "repositories.json", (error, data) ->
    svg.selectAll("path.datapoint").data(data).enter().append("path").datum((d) ->
      type: "Point"
      coordinates: [d.longitude, d.latitude]
      language: d.language
    ).attr("d", path).attr("class", "datapoint").style "fill", (d) ->
      color[d.language]

  color =
    Ruby: "red"
    JavaScript: "green"
    Python: "blue"
    Java: "yellow"
    CSS: "purple"
    "C++": "orange"
    PHP: "brown"
    Shell: "indigo"
    C: "pink"
    "Objective-C": "aqua"
