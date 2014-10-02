namespace :posts do
  desc "populating status_id from status"
  task :populate_status => :environment do
    Post.all.each do |post|
      post.update_column(:status_id, ::Posts::Status.find_by_name(post.read_attribute(:status)).id) if post.read_attribute(:status)
    end
  end

  desc "find place_id from location and set it"
  task :set_place => :environment do
    Post.all.each do |post|
      location = post.read_attribute(:location)
      api_key = "AIzaSyCRTakbzqUehny4QI1eDS3HQxuoHXCpVIk"
      url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?key=#{api_key}&input=#{location}"
      uri = URI.parse(URI.encode(url))
      http = Net::HTTP.new(uri.host,uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      http.use_ssl = true
      result = JSON.parse(http.request(request).body)
      begin
        post.set_api_place_id(result["predictions"].first["place_id"])
        post.save
      rescue 
      end
    end
  end

  desc "populate publisehd value"
  task :populate_published => :environment do
    Post.all.each do |post|
      if post.published == nil
        post.published = true
        post.save
      end
    end
  end
end