# Provides resources from public movie API (formerly http://imdbapi.org/).
# See http://mymovieapi.com/ for details.

class Movie < ActiveResource::Base
  self.site = 'http://mymovieapi.com'
  self.element_name = ''
  self.collection_name = ''

  alias_attribute :id, :imdb_id

  # Returns an array of movies that match title, default limit 1 (max 10).
  def self.find_all_by_title(title, limit=1)
    raise ArgumentError, "max limit on API for find_by_title is 10, #{limit} was provided" if limit > 10
    result = get('/', :title => title, :limit => limit)
    if result.is_a?(Hash) && result['error']
      ExceptionResponse.new result
    else
      result.collect{ |x| new(x) }
    end
  end

  # Returns single instance by title.
  def self.find_by_title(title)
    find_all_by_title(title).first
  end

  # Override find since this service doesn't implement REST the way Rails expects
  def self.find(id)
    result = get('/', :id => id)
   if result['error']
     ExceptionResponse.new result
   else
     new(result)
   end
  end
    
  # takes json response from service and creates exception
  # response example:  { "code" => 404, "error" => "Film not found" }
  class ExceptionResponse
    attr_reader :code, :message
    def initialize(response)
      @code    = response.fetch('code', 'Unknown')
      @message = response.fetch('error', nil)
      throw
    end

    private

    def throw
      case code
        when 404
          raise ActiveResource::ResourceNotFound, self
        when (400..499)
          raise ActiveResource::ClientError, self
        when (500..599)
          raise ActiveResource::ServerError, self
        else
          raise Exception, "Unhandled mymovieapi: #{code}: #{message}"
      end
    end
  end

end
