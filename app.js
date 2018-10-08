// from data.js
var tbody = d3.select('tbody');

// // YOUR CODE HERE!

console.log(data);

data.forEach((UFOsightings) => {
    var row = tbody.append("tr");
    Object.entries(UFOsightings).forEach(([key, value]) => {
      var cell = tbody.append("td");
      cell.text(value);
    });
  });

var btn = d3.select('#filter-btn');
var form = d3.select('form');

btn.on('click', function() {
    d3.event.preventDefault();
    
    var date = d3.select('#datetime').property('value')
    var filter = tableData.filter (row => row.datetime = date)
    var tbody = d3.select('tbody');
    tbody.html('')
filter.forEach((item) => {
    var row = tbody.append('tr');
    Object.entries(item).forEach(([key, value]) => {
        var cell = tbody.append('td');
        cell.text(value);
      });
    });
 });
  
