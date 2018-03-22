$(window).load(function() {
  // When the page has loaded
  $("body").show(0);
});

$("table").addClass("table");

// Add section hyperlinks
$(".overview").each(function() {
    var h2 = $("h2:first", this);
    //h2.append("<span class='fold-unfold glyphicon glyphicon-collapse-down'></span>");

    // var _sections = document.getElementsByClassName('section');
    var _sections = document.querySelectorAll(':not(.preview) > .section, :not(.preview) > .subsection');
    
    if( _sections.length > 0 ) {

      var row = document.createElement('div');
      row.className = 'row';

      var col = document.createElement('div');
      col.className = 'col-md-9';

      col.innerHTML += "<strong>Table of Contents</strong>";

      var ul = document.createElement('ul');
      var sublist = null;
      for (var i = 0, element; element = _sections[i]; i++) {
          if (element.className == "subsection") {
              if (sublist == null)
                sublist = document.createElement('ul');

              sublist.innerHTML += "<li><a href=\"#"+element.id+"\">"+element.innerHTML+"</a></li>";
          } else {
              if(sublist != null) {
                ul.appendChild(sublist);
                sublist = null;
              }
              ul.innerHTML += "<li><a href=\"#"+element.id+"\">"+element.innerHTML+"</a></li>";
          }
      }
      if(sublist != null) {
        ul.appendChild(sublist);
        sublist = null;
      }

      col.appendChild(ul);
      row.appendChild(col);
      this.appendChild(row);
    } else if( document.getElementById("prerequisites") == null ) {
        this.outerHTML = "";
    }
});

// Handle foldable challenges and solutions (on click and at start).
$(".discussion").click(function(event) {
    var trigger = $(event.target).has(".fold-unfold").size() > 0
               || $(event.target).filter(".fold-unfold").size() > 0;
    if (trigger) {
        $(">*:not(h2)", this).toggle(400);
        $(">h2>span.fold-unfold", this).toggleClass("glyphicon-collapse-down glyphicon-collapse-up");
        event.stopPropagation();
    }
});
$(".discussion").each(function() {
    $(">*:not(h2)", this).toggle();
    var h2 = $("h2:first", this);
    h2.append("<span class='fold-unfold glyphicon glyphicon-collapse-down'></span>");
});

// Handle downloadable data files and scripts (on click and at start).
$(".tutorial_files").each(function() {
    var h2 = $("h2:first", this);
    h2.prepend("<span onclick=get_files() title=\"Download Zip Archive\" class='download_files glyphicon glyphicon-download'></span>");
});

// Zip all files for download
function get_files() {

  var uld = document.getElementById("data_files");
  var uls = document.getElementById("scripts");

  if( uld == null && uls == null)
    return;

  var path = window.location.pathname.split('/');
  var name = "revbayes_"+path[path.length-2];

  var zip = new JSZip().folder(name);
  var d = zip.folder("data");
  var s = zip.folder("scripts");

  if( uld != null) {
    var _li = uld.getElementsByTagName("li");
    for (var i = 0; i < _li.length; ++i) {
      var file = _li[i].firstChild.innerHTML;
      d.file(file, $.get("data/"+file));
    }
  }
  if( uls != null) {
    var _li = uls.getElementsByTagName("li");
    for (var i = 0; i < _li.length; ++i) {
      var file = _li[i].firstChild.innerHTML;
      s.file(file, $.get("scripts/"+file));
    }
  }
  zip.generateAsync({type:"blob"})
    .then(function(content) {
      saveAs(content, name+".zip");
  });
}

if(location.search.substring(1) == 'download')
  get_files();

// Add figure titles to figure references
$("figure").each(function(index) {
    if( this.id != null ) {
      var els = document.querySelectorAll("a[href=\"#"+this.id+"\"]");
      if(els.length > 0)
        for (var i = 0, element; element = els[i]; i++)
          els[i].innerHTML="Figure " + (index+1);
    }
});

// Add section titles to section references
$(".section, .subsection").each(function(index) {
    if( this.id != null ) {
      var els = document.querySelectorAll("a[href=\"#"+this.id+"\"]");
      if(els.length > 0) {
        for (var i = 0, element; element = els[i]; i++)
          if( els[i].innerHTML == "")
            els[i].innerHTML=this.innerHTML;
      }
    }
});

// Process highlighted blocks
var _pre = document.querySelectorAll('pre.highlight');
for (var i = 0, element; element = _pre[i]; i++) {
  var classes = element.parentElement.parentElement.classList;
        
  var language = false;
  var Rev = false;
  for (var j = 0; j < classes.length; ++j) {
    if ( classes[j].match(/rev/i) != null )
      Rev = true;

    if ( classes[j].match(/language/) != null ) {
        language = true;
        break;
    }
  }

  if ( language )
    continue;

  var lines = element.textContent.split("\n").slice(0,-1);

  var open_brace = 0;
  var open_paren = 0;
  var open_curly = 0;
  var backslash = false;
  for (var line in lines) {
      var txt = "<span class='line'>"+lines[line]+"</span>";
      if ( open_brace || open_paren || open_curly || backslash )
        txt = "<span class='secondary'>"+lines[line]+"</span>";

      backslash = false;
      if ( lines[line].match(/\s\\\s*$/g) != null )
        backslash = true;

      lines[line] = txt;

      var myRegexp = /[\[\]\(\)\{\}]/g;
      match = myRegexp.exec(lines[line]);
      while (match != null) {
        if ( match == '[' )
          open_brace++;
        if ( match == '(' )
          open_paren++;
        if ( match == '{' )
          open_curly++;

        if ( open_brace && match == ']' )
          open_brace--;
        if ( open_paren && match == ')' )
          open_paren--;
        if ( open_curly && match == '}' )
          open_curly--;

        match = myRegexp.exec(lines[line]);
      }
  }

  element.innerHTML=lines.join("\n");
  // Italicize comments
  if( Rev )
    element.innerHTML = element.innerHTML.replace(/(#[^<]*)/g,"<i>$1</i>");
}

// Handle searches.
// Relies on document having 'meta' element with name 'search-domain'.
function google_search() {
  var query = document.getElementById("google-search").value;
  var domain = $("meta[name=search-domain]").attr("value");
  window.open("https://www.google.com/search?q=" + query + "+site:" + domain);
}
