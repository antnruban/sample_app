require 'spec_helper'

describe SearchImagesHelper do
  describe "'search_results' method" do
    it "returns data" do
      params['search_query'] = "image"

      search_results.should be
    end

    it "is encoded" do
      params['search_query'] = "картинка"

      search_results.should be
    end
  end

  describe "API URL" do
    it "is working" do
      url_answer = open(GOOGLE_IMAGE_API_URL).read

      url_answer.should be
    end
  end
end
