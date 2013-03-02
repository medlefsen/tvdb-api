TVDB API
========

Yet another Ruby client for the TVDB ( http://thetvdb.com ).

  * Clean and fully featured API client that streamlines usage but gets out of your way when you need it to.
  * Supports all non-deprecated aspects of the TVDB Api.
  * Uses compression for all calls making the API very quick.
  * All XML responses parsed into simple Ruby Hash structure.

See http://thetvdb.com/wiki/index.php?title=Programmers_API for documentation of API.

Usage
-----

    client = TVDBApi.new API_KEY
    # or
    client = TVDBApi.new API_KEY, 'en'

    # Dynamic Interfaces
    client.get_series 'Futurama'
    client.get_series_by_remote_id :imdb, 'tt0149460'
    
    ## Files Interface

    client['updates_day.xml']
    
    # Adds .xml for you
    client['languages'] # => languages.xml

    # Automatically gets the default language if not specified
    client['series/73871'] => series/73871/en.xml

    # Allows array input for more structured calls
    client[:series, 73871, :default, 1, 1] => 'series/73871/default/1/1/en.xml'
