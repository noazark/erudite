class SearchController < ApplicationController
  def show
    query = params[:search]
    @results = Document.search page: params[:page], per_page: params[:per_page] do
      query do
        string query
      end
    end

    respond_to do |format|
      format.html
    end
  end
end
