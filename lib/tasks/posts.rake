namespace :posts do
  desc "populating status_id from status"
  task :populate_status => :environment do
    Post.all.each do |post|
      post.update_column(:status_id, ::Posts::Status.find_by_name(post.read_attribute(:status)).id) if post.read_attribute(:status)
    end
  end
end