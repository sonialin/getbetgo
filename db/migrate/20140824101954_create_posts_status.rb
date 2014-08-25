class CreatePostsStatus < ActiveRecord::Migration
  def change
    create_table :posts_statuses do |t|
      t.string :name
    end

    ::Posts::Status.create(:name => 'Paid')
    ::Posts::Status.create(:name => 'Drafted')
  end
end