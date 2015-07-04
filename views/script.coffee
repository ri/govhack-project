graph = (e, data) ->

	contain = d3.select(".content")
	# svg = contain.append("svg").attr(height: "100%").attr(width: "100%")

	dataByHousehold = d3.nest()
		.key((d) -> d.respondent)
		.entries(data)

	dataByDate = d3.nest()
		.key((d) -> d["OUTPUT_DATE"])
		.entries(data)

	dayIndex = 120

	dayData = dataByDate[dayIndex].values.filter((d) -> d["TYPE"] is "general")

	dayData = ({id: day["respondent"], data: day["OUTPUT_DATE"], entries: d3.entries(day).slice(3)} for day in dayData)

	dayMin = d3.min(dayData, (d) -> d3.min(d.entries, (e) -> +e.value))
	dayMax = d3.max(dayData, (d) -> d3.max(d.entries, (e) -> +e.value))
	dataLength = dayData[0].entries.length
	console.log dataLength

	size = 200
	speed = 400
	index = 0
	elapsed = 0

	dayScale = d3.scale.pow().domain([dayMin, dayMax]).range([0, size/2])

	households = contain.selectAll("svg")
		.data(dayData)
		.enter()
		.append("svg")
		.attr(width: size)
		.attr(height: size)

	circles = households.append("circle")
		.attr(cx: size/2)
		.attr(cy: size/2)
		.attr(fill: "white")
		.attr(r: 0)

	interval = setInterval(() ->
		if index >= (dataLength - 1) then index = 0
		circles.transition()
			.duration(speed)
			.attr(r: (d) -> dayScale +d.entries[index].value)
		index++
	, speed)




		

queue()
	.defer(d3.csv, 'data/energy-consumption.csv')
	.await(graph)