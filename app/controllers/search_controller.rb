class SearchController < ApplicationController
  def show
    query = params[:search]
    
    if !query.blank?
      @results = Document.search page: params[:page], per_page: params[:per_page] do
        query do
          string query
        end
      end
    end

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end
end
