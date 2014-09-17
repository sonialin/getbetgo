ActiveAdmin.register Post do


  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end

  permit_params :subcategory_id

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    column :title
    column :price
    column :quantity
    column :subcategory_id do |post|
      post.category.name
    end
    column :subcategory_id do |post|
      post.subcategory.name
    end
    column :created_at
    column :updated_at
    column :user_id do |post|
      post.user.name
    end
    actions
  end

end
