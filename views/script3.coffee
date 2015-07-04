graph = (e, data) ->

	contain = d3.select(".content")
	# svg = contain.append("svg").attr(height: "100%").attr(width: "100%")

	dataByHousehold = d3.nest()
		.key((d) -> d.respondent)
		.entries(data)

	dataByDate = d3.nest()
		.key((d) -> d["OUTPUT_DATE"])
		.entries(data)

	console.log dataByDate

	dayIndex = 118

	dayData = dataByDate[dayIndex].values.filter((d) -> d["TYPE"] is "general")

	dayData = ({id: day["respondent"], data: day["OUTPUT_DATE"], entries: d3.entries(day).slice(3)} for day in dayData)

	dayMin = d3.min(dayData, (d) -> d3.min(d.entries, (e) -> +e.value))
	dayMax = d3.max(dayData, (d) -> d3.max(d.entries, (e) -> +e.value))

	numHouseholds = dataByHousehold.length
	dataLength = dayData[0].entries.length
	console.log dataLength

	size = 100
	speed = 200
	index = 0
	elapsed = 0
	width = 1200
	height = 800
	bg = "dark"

	dayScale = d3.scale.pow().domain([dayMin, dayMax]).range([0, size/2])
	posScale = d3.scale.linear().domain([dayMin, dayMax]).range([height - 100, 100])

	body = d3.select("body")
	svg = contain.append("svg")
		.attr(width: width)
		.attr(height: height)

	body.style(background: "#000")
	body.transition()
		.duration(9000)
		.style(background: "#454f5a")

	circles = svg.selectAll("circle")
		.data(dayData)
		.enter()
		.append("circle")
		.attr(cx: () -> (Math.random() * (width - 100)) + 100)
		.attr(cy: () -> (Math.random() * (height - 100)) + 100)
		.attr(fill: "white")
		.attr(r: 0)

	interval = setInterval(() ->
		if index >= (dataLength - 1) then index = 0

		if index >= dataLength/2 and bg is "dark"
			console.log "hello!"
			body.transition().duration(9000).style(background: "#454f5a")
			bg = "light"
		else if index < dataLength/2 and bg is "light"
			body.transition()
				.duration(9000)
				.style(background: "#000")
			bg = "dark"

		circles.transition()
			.duration(speed)
			.ease("quad")
			.attr(r: (d) -> dayScale +d.entries[index].value)
		index++
	, speed)




		

queue()
	.defer(d3.csv, 'data/energy-consumption.csv')
	.await(graph)