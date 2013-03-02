require 'httparty'

class TVDBApi
  include HTTParty
  format :xml
  base_uri 'http://www.thetvdb.com'
  headers 'Accept-encoding' => 'gzip'

  def initialize(api_key,opts = {})
    @lang = opts[:lang] || 'en'
    @api_key = api_key
    @tries = 3
  end

  def get_series(series_name, lang = @lang)
    get 'GetSeries.php', seriesname: series_name, language: lang
  end

  def get_series_by_remote_id(type, id, lang = @lang)
    query = {language: lang}
    case type
    when :imdb then query[:imdbid] = id
    when :zap2it then query[:zap2it] = id
    else raise "Invalid remote id type '#{type}'"
    end
    get 'GetSeriesByRemoteID.php', query
  end

  def get_episode_by_air_date(series_id, air_date, lang = @lang)
    if air_date.respond_to? :to_time
      air_date = air_date.to_time
    end
    if air_date.respond_to? :strftime
      air_date = air_date.strftime('%F')
    end

    get 'GetEpisodeByAirDate.php', 
      apikey: @api_key, language: lang,
      seriesid: series_id, airdate: air_date
  end

  def get_retings_for_user(account_id, series_id = nil)
    query = { apikey: @api_key, accountid: account_id }
    query[:seriesid] = series_id if series_id
    get 'GetRatingsForUser.php', query
  end

  def user_preferred_language(account_id)
    get 'User_PreferredLanguage.php', accountid: account_id
  end

  def user_favorites(account_id, change = nil, series_id = nil)
    query = {accountid: account_id}
    if change
      if [:add,:remove].include?(change) && series_id
        query[:type] = change
        query[:seriesid] = series_id
      else
        raise ArgumentError.new("change may only be :add or :remove and series_id must be set if change is set")
      end
    end
    get 'User_Favorites.php', query
  end

  def user_rating(account_id, item_type, item_id, rating)
    get 'User_Rating.php',
      accountid: account_id, itemtype: item_type,
      itemid: itemid, rating: rating
  end

  def to_full(path)
    if path !~ /\.php$/
      path = @api_key+'/'+path

      if path =~ /\/\d+(\/all)?\/?$/
        path += '/' + @lang + '.xml'
      end

      if path =~ /(.*\/updates\/)(?!updates_)(.*)/
        path = $1+"updates_"+$2
      end

      if path =~ /\/[^\/\.]*$/
        path += '.xml'
      end
    end

    if path[0] != '/'
      if path !~ /^?api\//
        path = '/api/'+path
      else
        path = '/' + path 
      end
    end

    path
  end

  def get(path,query=nil, options={})
    if path.respond_to? :join
      path = path.join("/")
    end
    path = to_full path
    if query
      options[:query] = query
    end
    ex = nil
    @tries.times do
      begin
        res = self.class.get(path,options)
        return res
      rescue => e
        ex = e
      end
    end
    raise ex
  end

  def [](*args)
    get args
  end

end
