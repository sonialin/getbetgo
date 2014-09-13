class PlacesController < ApplicationController
  def prediction
    keyword = "%#{params[:q].upcase}%"
    predictions = Place.get_predictions(keyword)
    render :json => predictions, :status => 200
  end
end
