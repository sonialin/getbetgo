namespace :subcategory do
  desc "transfering posts from categories to subcategories"
  task :populate => :environment do 
    Post.all.each do |post|
      post.update_column(:subcategory_id, post.category.subcategories.first.id) unless post.subcategory
    end
  end
end