class TagsController < ApplicationController
  def prediction
    keyword = "%#{params[:q].upcase}%"
    predictions = ActsAsTaggableOn::Tag.where("UPPER(name) LIKE ?",keyword).limit(10).order("name").select("tags.id as id, LOWER(tags.name) as name")
    render :json => predictions, :status => 200
  end
end
