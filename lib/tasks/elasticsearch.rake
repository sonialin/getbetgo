namespace :elasticsearch do
  desc "Reindex all posts"
  task :reindex => :environment do
    INDEX_NAME = "posts"
    TYPE_NAME = "posts".singularize
    es_api = Posts::ElasticsearchApi.new
    es_api.create_index
    Post.all.each{ |post| es_api.insert_post(post.id)}
  end
end