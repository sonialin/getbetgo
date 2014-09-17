ActiveAdmin.register Subcategory do


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
  permit_params :name, :category_id

  def scoped_collection
    end_of_association_chain.includes(:category)
  end

  index do
    column "Subcategory", :sortable => :subcategory do |subcategory|
      subcategory.name
    end
    column Category.name, :category, :sortable => 'categories.name'
    column :created_at
    column :updated_at
    actions
  end

end