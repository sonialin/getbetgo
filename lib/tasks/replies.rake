namespace :replies do
  desc "set private to false if nil"
  task :set_private_field_value => :environment do
    Reply.all.each do |reply|
    	if reply.private == nil
    		reply.private = false
        reply.save
    	end
    end
  end
end