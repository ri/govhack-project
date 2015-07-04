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

	size = 100
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

	hands = households.append("rect")
		.attr(height: size/2)
		.attr(width: 1)
		.attr(fill: "white")
		.attr(x: size/2 - 0.5)
		.attr(y: size/4)

	interval = setInterval(() ->
		if index >= (dataLength - 1) then index = 0
		hands.transition()
			.duration(speed)
			.attr(width: (d) -> dayScale +d.entries[index].value)
			.attr(x: (d) -> size/2 - dayScale +d.entries[index].value/2)
			.attr(transform: "rotate(#{index/dataLength * 360}, #{size/2}, #{size/2})")
		index++
	, speed)




		

queue()
	.defer(d3.csv, 'data/energy-consumption.csv')
	.await(graph)