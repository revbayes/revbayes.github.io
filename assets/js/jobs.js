var future = document.createElement('table');
future.className = 'table table-striped';
future.style.width="100%";

present = future.cloneNode(true);
past = future.cloneNode(true);

var header = document.createElement('tr');
header.innerHTML = "<td width=\"15%\"><b>Application Date</b></td><td width=\"25%\"><b>Job Title</b></td><td width=\"25%\"><b>Location</b></td><td width=\"25%\"><b>PI</b></td>";

future.appendChild(header);
present.appendChild(header.cloneNode(true));
past.appendChild(header.cloneNode(true));

$(".event").each(function() {
	var dates = this.id.split("-");

	var appl = parseInt(dates[0]);
	var now = Math.floor(new Date().getTime() / 1000 / 3600 / 24);

	if( appl > now )
	{
		present.appendChild(this);
	}
	else
	{
		past.appendChild(this);
	}
});

$("#jobs tr:not(.event):not(.header)").each(function() {
	past.appendChild(this);
});

$("#jobs").each(function() {
	this.innerHTML = "";
	if( present.childElementCount > 1 )
	{
		this.innerHTML += "<div id=\"Current\"><h3>Current Job Advertisements</h3>";
		this.appendChild(present);
		this.innerHTML += "</div>";
	}
	if( past.childElementCount > 1 )
	{
		this.innerHTML += "<div id=\"past\"><h3>Past Job Advertisements</h3>";
		this.appendChild(past);
		this.innerHTML += "</div>";
	}
});
