// Create an array of all script files and their contents
var scripts = {};
var _code = document.querySelectorAll('pre');
for (var i = 0, element; element = _code[i]; i++) {
  var output = element.parentElement.parentElement.getAttribute("output");
  if( typeof scripts[output] == 'undefined' )
    scripts[output] = "";
  scripts[output] += element.firstChild.innerHTML.replace(/&lt;/g,'<')+"\n";
}

// Retrieve script file for download
function get_script(script) {
  var blob = new Blob([scripts[script]], {type: "text/plain;charset=utf-8"});
  saveAs(blob, script);
}

// Zip all files for download
function get_files() {

  var path = window.location.pathname.split('/');
  var name = "revbayes_"+path[path.length-2];

  var zip = new JSZip().folder(name);

  var s = zip.folder("scripts");
  for(var script in scripts) {
    if( script != "null") {
      s.file(script, scripts[script]);
    }
  }

  var ul = document.getElementById("data_files");

  var d = zip.folder("data");
  var _li = ul.getElementsByTagName("li");
  for (var i = 0; i < _li.length; ++i) {
    var file = _li[i].firstChild.innerHTML;
    d.file(file, $.get("data/"+file));
  }
  zip.generateAsync({type:"blob"})
    .then(function(content) {
      // see FileSaver.js
      saveAs(content, name+".zip");
  });
}

// Handle downloadable data files and scripts (on click and at start).
$(".tutorial_files").each(function() {
    var h2 = $("h2:first", this);
    h2.prepend("<span onclick=get_files() title=\"Download Zip Archive\" class='download_files glyphicon glyphicon-download'></span>");
    //h2.append("<span class='fold-unfold glyphicon glyphicon-collapse-down'></span>");

    var ul = document.createElement('ul');
    var i = 0;
    for(var script in scripts) {
      if( script != "null") {
        ul.innerHTML += "<li><a onclick=get_script(\""+script+"\") onmouseover=\"\" style=\"cursor: pointer;\">"+script+"</a></li>";
        i++;
      }
    }

    if( i > 0 ) {
      var row = document.createElement('div');
      row.className = 'row';

      var col = document.createElement('div');
      col.className = 'col-md-9';

      col.innerHTML += "<strong>Scripts</strong>";

      col.appendChild(ul);
      row.appendChild(col);
      this.appendChild(row);

      //$(">*:not(h2)", this).toggle();
    } else if( document.getElementById("data_files") == null ) {
        this.outerHTML = "";
    }
});

// Revify highlight blocks
var _pre = document.querySelectorAll('pre');
for (var i = 0, element; element = _pre[i]; i++) {
  var lines = element.textContent.split("\n").slice(0,-1);

  var open_brace = false;
  var open_paren = false;
  var open_curly = false;
  var open_slash = false;
  for (var line in lines) {
      if ( open_brace || open_paren || open_curly ) {
        lines[line] = "<span class='secondary'>"+lines[line]+"</span>";
      } else {
        lines[line] = "<span class='line'>"+lines[line]+"</span>";
      }

      if ( lines[line].match(/\[[^\]]*$/) != null ) {
        open_brace = true;
      }
      if ( lines[line].match(/\([^\)]*$/) != null ) {
        open_paren = true;
      }
      if ( lines[line].match(/\{[^\}]*$/) != null ) {
        open_curly = true;
      }
      if ( lines[line].match(/\\\s*$/) != null ) {
        open_slash = true;
      }

      if ( lines[line].match(/\][^\[]]*$/) != null ) {
        open_brace = false;
      }
      if ( lines[line].match(/\)[^\()]*$/) != null ) {
        open_paren = false;
      }
      if ( lines[line].match(/\}[^\{}]*$/) != null ) {
        open_curly = false;
      }
  }

  element.innerHTML=lines.join("\n");
  // Italicize comments
  if ( element.parentElement.parentElement.classList == "highlighter-rouge" )
    element.innerHTML = element.innerHTML.replace(/(#[^<]*)/g,"<i>$1</i>");
}