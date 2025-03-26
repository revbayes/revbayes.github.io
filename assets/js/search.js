
(function() {
  function showResults(results, store) {
    var searchResults = document.getElementById('search-results');

    if (results.length) { // If there are results...
      var appendString = '<br>';

      for (var i = 0; i < results.length; i++) {  // Iterate over them and generate html
        var item = store[results[i].ref];
        appendString += '<li><a href="' + item.url + '"><b>' + item.title + '</b></a>';
        appendString += '<p>' + item.content.substring(0, 250) + '...</p></li>';
      }

      searchResults.innerHTML = appendString;
    } else {
      searchResults.innerHTML = '<br><li>No results found</li>';
    }
  }

  function getQuery(variable) {
    var query = window.location.search.substring(1);
    var vars = query.split('&');

    for (var i = 0; i < vars.length; i++) {
      var pair = vars[i].split('=');

      if (pair[0] === variable) {
        return decodeURIComponent(pair[1].replace(/\+/g, '%20'));
      }
    }
  }

  var searchTerm = getQuery('query');

  if (searchTerm) {
    document.getElementById('search-box-page').setAttribute("value", searchTerm);

    // Initalize lunr.js with the fields to search.
    // The title field is given more weight with the "boost" parameter
    var idx = lunr(function () {
      this.field('id');
      this.field('title', { boost: 10 });
      this.field('content');

      for (var key in window.store) { // Add the JSON we generated from the site content to Lunr.js.
        if (!(window.store[key].index == "false")) {
          this.add({
            'id': key,
            'title': window.store[key].title,
            'content': window.store[key].content,
            'index': window.store[key].index
          });
        }
      }
    });

    var results = idx.search(searchTerm); // Perform search with Lunr.js
    showResults(results, window.store);
  }
})();
