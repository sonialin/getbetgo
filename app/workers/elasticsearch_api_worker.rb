require 'heroku_resque_auto_scale.rb'

class ElasticsearchApiWorker
  extend HerokuResqueAutoScale
  @queue = :es_api_requests

  def self.perform(*args)
    post_id = args[0]
    es_api = Posts::ElasticsearchApi.new
    es_api.insert_post(post_id)
  end
end