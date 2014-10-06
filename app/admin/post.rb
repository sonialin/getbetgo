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

  permit_params :subcategory_id, :user_id, :status_id, :city_id, :title, :description, :price, :quantity, :image_file_name, :image_content_type, :image_file_size, :image_updated_at, :slug, :service, :criteria, :published 

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
    def scoped_collection
      end_of_association_chain.includes(:subcategory)
    end
  end

  index do
    column :title
    column :price
    column :quantity
    column Category.name, :category, :sortable => 'categories.name'
    column Subcategory.name, :subcategory, :sortable => 'subcategories.name'
    column :created_at
    column :updated_at
    column :user_id do |post|
      post.user.name
    end
    actions
  end

end
