console.log('Loading search.js')
(function() {
  // Read query that is submitted through search bar
  // e.g. turn "http://127.0.0.1:4000/search/?query=biogeography" -> "biogeography"
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

  // Process
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
      searchResults.innerHTML = '<li>No results found</li>';
    }
  }


  var searchTerm = getQuery('query');

  if (searchTerm) {
    document.getElementById('search-box').setAttribute("value", searchTerm);

    // Initalize lunr.js with the fields to search.
    // The title field is given more weight with the "boost" parameter
    var idx = lunr(function () {
      this.field('id');
      this.field('title', { boost: 10 });
      this.field('content');

      for (var key in window.store) { // Add the JSON we generated from the site content to Lunr.js.
        this.add({
          'id': key,
          'title': window.store[key].title,
          'content': window.store[key].content
        });
      }
    });

    var results = idx.search(searchTerm); // Perform search with Lunr.js
    showResults(results, window.store);
  }
})();

