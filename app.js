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