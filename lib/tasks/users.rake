namespace :users do
  desc "set identifier if nil"
  task :populate_identifiers => :environment do
    User.all.each do |user|
      if user.identifier == nil
        user.identifier = loop do
          random_identifier = SecureRandom.hex(5)
          break random_identifier unless User.all.pluck(:identifier).include?(random_identifier)
        end
        user.save
      end
    end
  end
end