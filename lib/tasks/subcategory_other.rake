namespace :subcategory_other do
  desc "add other subcategory in every category"
  task :populate => :environment do
    Category.all.each do |category|
    	subcategory = Subcategory.new(:name => "Other", :category_id => category.id)
    	subcategory.save
    end
  end
end