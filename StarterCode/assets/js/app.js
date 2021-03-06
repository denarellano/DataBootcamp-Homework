// @TODO: YOUR CODE HERE!
var svgWidth = 825;
var svgHeight = 500;

var margin = {
    top: 20,
    right: 40,
    bottom: 60,
    left: 100
};

var width = svgWidth - margin.left - margin.right;
var height = svgHeight - margin.top - margin.bottom;

var svg = d3.select('#scatter')
    .append('svg')
    .attr('width', svgWidth)
    .attr('height', svgHeight);

var chartGroup = svg.append('g')
    .attr('transform', `translate(${margin.left}, ${margin.top})`);

d3.csv('assets/data/data.csv').then(function(data) {
    data.forEach(function(d) {
        d.poverty = +d.poverty;
        d.healthcare = +d.healthcare;
    });

    var xLinearScale = d3.scaleLinear()
        .domain([d3.min(data, d => d.poverty)-1, d3.max(data, d => d.poverty)])
        .range([0, width]);
    
    var yLinearScale = d3.scaleLinear()
        .domain([0, d3.max(data, d => d.healthcare)])
        .range([height, 0]);
    
    var bottomAxis = d3.axisBottom(xLinearScale);
    var leftAxis = d3.axisLeft(yLinearScale);

    chartGroup.append('g')
        .attr('transform', `translate(0, ${height})`)
        .call(bottomAxis);
    
    chartGroup.append('g')
        .call(leftAxis);
    
    var circlesGroup = chartGroup.selectAll('circle')
        .data(data)
        .enter()
        .append('circle')
        .attr('cx', d => xLinearScale(d.poverty))
        .attr('cy', d => yLinearScale(d.healthcare))
        .attr('r', '10')
        .attr('class', 'stateCircle')
        .attr('opacity', '.75');
    
    var toolTip = d3.tip('.d3-tip')
        .attr('class', 'd3-tip')
        .html(function(d) {
            return (`${d.state}<br>Poverty: ${d.poverty}%<br>Healthcare: ${d.healthcare}%`);
        });
    
    chartGroup.call(toolTip);

    circlesGroup.on('mouseover', toolTip.show);
    circlesGroup.on('mouseout', toolTip.hide);

    chartGroup.selectAll('text.stateText')
        .data(data)
        .enter()
        .append('text')
        .attr('class', 'stateText')
        .text(d => d.abbr)
        .attr('x', d => xLinearScale(d.poverty))
        .attr('y', d => yLinearScale(d.healthcare)+4);
    
    chartGroup.append('text')
        .attr('transform', 'rotate(-90)')
        .attr('y', 0 - margin.left + 40)
        .attr('x', 0 - (height / 2))
        .attr('dy', '1em')
        .attr('class', 'axisText')
        .text('Lacks Healthcare (%)');
    
    chartGroup.append('text')
        .attr('transform', `translate(${width / 2}, ${height + margin.top + 30})`)
        .attr('class', 'axisText')
        .text('In Poverty (%)');
});