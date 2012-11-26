class DocumentsController < ApplicationController
  # GET /documents
  # GET /documents.json
  def index
    @documents = Document.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @documents }
    end
  end

  # GET /documents/1
  # GET /documents/1.json
  def show
    @document = Document.find_by(slug: params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @document }
    end
  end

  # GET /documents/new
  # GET /documents/new.json
  def new
    @document = Document.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @document }
    end
  end

  # POST /documents
  # POST /documents.json
  def create
    respond_to do |format|
      @document = Document.new params[:document]

      if @document.valid?
        Resque.enqueue(Cache, @document.uri)
        format.html { redirect_to documents_path, notice: 'Document has been added to queue.' }
        format.json { render json: @document, status: :created, location: @document }
      else
        format.html { render action: "new" }
      end
    end
  end

  # DELETE /documents/1
  # DELETE /documents/1.json
  def destroy
    @document = Document.find_by(slug: params[:id])
    @document.destroy

    respond_to do |format|
      format.html { redirect_to documents_url }
      format.json { head :ok }
    end
  end
end
