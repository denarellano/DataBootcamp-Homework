var url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"

var mag = [];
var lon = [];
var lat = [];
var place = [];

d3.json(url, function(data){
    thedata = data.features
    console.log(thedata)
    thedata.forEach(d => {
        mag.push(d.properties.mag)
        lon.push(d.geometry.coordinates[0])
        lat.push(d.geometry.coordinates[1])
        place.push(d.properties.place)
    })

    var myMap = L.map("map", {
        center: [37.09, -95.71],
        zoom: 5,
        // layers: [streetmap, earthquakes]
    });

    L.tileLayer("https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}.png?access_token={accessToken}", {
        attribution: "Map data &copy; <a href=\"https://www.openstreetmap.org/\">OpenStreetMap</a> contributors, <a href=\"https://creativecommons.org/licenses/by-sa/2.0/\">CC-BY-SA</a>, Imagery © <a href=\"https://www.mapbox.com/\">Mapbox</a>",
        maxZoom: 18,
        id: "mapbox.streets-basic",
        accessToken: API_KEY
    }).addTo(myMap);

    function color(scale){
        if (scale < 2.5) {
            return "#ffff66"
        } else if (scale < 5.5) {
            return "#ffc266"
        } else if (scale < 7.0) {
            return "#ff5c33"
        } else {
            return "#cc0000"
        }
    }

    for(var i =0; i < mag.length; i ++) {
        L.circle([lat[i],lon[i]], {
            fillOpacity: .75,
            color: color(mag[i]),
            fillColor: color(mag[i]),
            radius: mag[i]*10000
        }).bindPopup("<h3>" + place[i] + "</h3><h3> Magnitude: " + mag[i] + "</h3>").addTo(myMap);
    }
    
    var legend = L.control.scale({
        position: "bottomright"
    });

    legend.onAdd = function() {
        var div = L
            .DomUtil
            .create("div", "Info Legend");
        
        var grades = [2.5, 5.5, 7.0, 7.9];
        var colors = [
            "#ffff66",
            "#ffc266",
            "#ff5c33",
            "#cc0000",
        ];
    
    for (var i = 0; i < grades.length; i++) {
        div.innerHTML += "<i style='background: " + colors[i] + "'></i>" +
        grades[i] + (grades[i + 1] ? "&ndash;" + grades[i + 1] + "<br>" : "+");
    }
    return div;
    };

    legend.addTo(myMap);

});

