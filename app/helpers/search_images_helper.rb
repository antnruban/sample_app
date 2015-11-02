require 'open-uri'

GOOGLE_IMAGE_API_URL = "https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q="

module SearchImagesHelper
  def search_results
    query = params['search_query']

    return if query.nil?
    encoded_url = URI.encode(GOOGLE_IMAGE_API_URL + query)
    answer = open(encoded_url).read
    answer_hash = JSON.parse answer
    answer_hash['responseData']['results'].map { |obj| obj['unescapedUrl'] }
  end
end
