$(window).load(function() {
  // When the page has loaded
  $("body").show(0);
});

$("table").addClass("table");

// Add section hyperlinks
$(".overview").each(function() {
    var h2 = $("h2:first", this);
    //h2.append("<span class='fold-unfold glyphicon glyphicon-collapse-down'></span>");

    var _sections = document.getElementsByClassName('section');
    
    if( _sections.length > 0 ) {
      var row = document.createElement('div');
      row.className = 'row';

      var col = document.createElement('div');
      col.className = 'col-md-9';

      col.innerHTML += "<strong>Sections</strong>";

      var ul = document.createElement('ul');
      for (var i = 0, element; element = _sections[i]; i++) {
        ul.innerHTML += "<li><a href=\"#"+element.id+"\">"+element.innerHTML+"</a></li>";
      }

      col.appendChild(ul);
      row.appendChild(col);
      this.appendChild(row);
    }
});

// Handle foldable challenges and solutions (on click and at start).
$(".challenge,.discussion,.solution,.tutorial_files,.overview").click(function(event) {
    var trigger = $(event.target).has(".fold-unfold").size() > 0
               || $(event.target).filter(".fold-unfold").size() > 0;
    if (trigger) {
        $(">*:not(h2)", this).toggle(400);
        $(">h2>span.fold-unfold", this).toggleClass("glyphicon-collapse-down glyphicon-collapse-up");
        event.stopPropagation();
    }
});
$(".challenge,.discussion,.solution").each(function() {
    $(">*:not(h2)", this).toggle();
    var h2 = $("h2:first", this);
    h2.append("<span class='fold-unfold glyphicon glyphicon-collapse-down'></span>");
});

// Handle searches.
// Relies on document having 'meta' element with name 'search-domain'.
function google_search() {
  var query = document.getElementById("google-search").value;
  var domain = $("meta[name=search-domain]").attr("value");
  window.open("https://www.google.com/search?q=" + query + "+site:" + domain);
}