var future = document.createElement('table');
future.className = 'table table-striped';
future.style.width="100%";

present = future.cloneNode(true);
past = future.cloneNode(true);

var header = document.createElement('tr');
header.innerHTML = "<td width=\"15%\"><b>Date</b></td><td width=\"25%\"><b>Course Title</b></td><td width=\"25%\"><b>Location</b></td><td width=\"25%\"><b>Instructors</b></td>";

future.appendChild(header);
present.appendChild(header.cloneNode(true));
past.appendChild(header.cloneNode(true));

$(".event").each(function() {
	var dates = this.id.split("-");

	var start = parseInt(dates[0]);
	var end = parseInt(dates[1]);
	var now = Math.floor(new Date().getTime() / 1000 / 3600 / 24);

	if( start > now )
	{
		future.appendChild(this);
	}
	else if( start <= now && end >= now )
	{
		present.appendChild(this);
	}
	else if( end < now )
	{
		past.appendChild(this);
	}
});

$("#workshops tr:not(.event):not(.header)").each(function() {
	past.appendChild(this);
});

$("#workshops").each(function() {
	this.innerHTML = "";
	if( future.childElementCount > 1 )
	{
		this.innerHTML += "<div id=\"future\"><h3>Future Workshops</h3>";
		this.appendChild(future);
		this.innerHTML += "</div>";
	}
	if( present.childElementCount > 1 )
	{
		this.innerHTML += "<div id=\"present\"><h3>Workshops Currently In Progress</h3>";
		this.appendChild(present);
		this.innerHTML += "</div>";
	}
	if( past.childElementCount > 1 )
	{
		this.innerHTML += "<div id=\"past\"><h3>Past Workshops</h3>";
		this.appendChild(past);
		this.innerHTML += "</div>";
	}
});
