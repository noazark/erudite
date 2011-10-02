class SearchController < ApplicationController
  def show
    @documents = Document.search params[:search],
                   page: params[:page],
                   per_page: params[:per_page] rescue

    respond_to do |format|
      format.html
    end
  end
end
