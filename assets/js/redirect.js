var url = window.location.href;

var res = url.replace("/revbayes-site", "");

if( res != url )
{
	//var x = document.getElementsByClassName("not_found").item(0);
	//x.innerHTML = "This page has been <a href=\""+res+"\">moved</a>";

	window.location = res;
}