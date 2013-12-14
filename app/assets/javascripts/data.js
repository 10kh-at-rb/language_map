$(document).ready(function(){
  var width = 1200,
      height = 800;

  var projection = d3.geo.orthographic()
      .scale(400)
      .translate([width / 2, height / 2])
      .clipAngle(90);

  var path = d3.geo.path()
      .projection(projection);

  path.pointRadius(2);

  var λ = d3.scale.linear()
      .domain([0, width])
      .range([-180, 180]);

  var φ = d3.scale.linear()
      .domain([0, height])
      .range([90, -90]);

  var svg = d3.select("body").append("svg")
      .attr("width", width)
      .attr("height", height);

  svg.on("mousemove", function() {
    var p = d3.mouse(this);
    projection.rotate([λ(p[0]), φ(p[1])]);
    svg.selectAll("path").attr("d", path);
  });

  svg.append("circle")
      .attr("cx", width / 2)
      .attr("cy", height / 2)
      .attr("r", projection.scale())
      .attr("class", "globe");

  d3.json("data/map_json.json", function(error, world) {
    svg.append("path")
        .datum(topojson.feature(world, world.objects.land))
        .attr("class", "land")
        .attr("d", path);

    svg.append("path")
        .datum(topojson.mesh(world, world.objects.countries, function(a, b) { return a !== b; }))
        .attr("class", "boundary")
        .attr("d", path);
  });

  d3.json("repositories.json", function(error, data) {
    svg.selectAll("path.datapoint")
        .data(data)
        .enter()
        .append("path")
        .datum(function(d) {
          return {
            type: "Point",
            coordinates: [d.longitude, d.latitude],
            language: d.language
          };
        })
        .attr("d", path)
        .attr("class", "datapoint")
        .style("fill", function(d){
           return color[d.language];
         });
  });

  var color = {
    "Ruby"       : "red",
    "JavaScript" : "green",
    "Python"     : "blue",
    "Java"       : "yellow",
    "CSS"        : "purple",
    "C++"        : "orange",
    "PHP"        : "brown",
    "Shell"      : "indigo",
    "C"          : "pink"
  };
});
