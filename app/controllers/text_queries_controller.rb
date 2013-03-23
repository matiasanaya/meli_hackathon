class TextQueriesController < ApplicationController
  # GET /text_queries
  # GET /text_queries.json
  def index
    @text_queries = TextQuery.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @text_queries }
    end
  end

  # GET /text_queries/1
  # GET /text_queries/1.json
  def show
    @text_query = TextQuery.find(params[:id])
     @stuff = @text_query.chart
     @chart = @stuff[:chart]
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @text_query }
    end
  end

  # GET /text_queries/new
  # GET /text_queries/new.json
  def new
    @text_query = TextQuery.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @text_query }
    end
  end

  # GET /text_queries/1/edit
  def edit
    @text_query = TextQuery.find(params[:id])
  end

  # POST /text_queries
  # POST /text_queries.json
  def create
    @text_query = TextQuery.new(params[:text_query])

    respond_to do |format|
      if @text_query.save
        format.html { redirect_to @text_query, notice: 'Text query was successfully created.' }
        format.json { render json: @text_query, status: :created, location: @text_query }
      else
        format.html { render action: "new" }
        format.json { render json: @text_query.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /text_queries/1
  # PUT /text_queries/1.json
  def update
    @text_query = TextQuery.find(params[:id])

    respond_to do |format|
      if @text_query.update_attributes(params[:text_query])
        format.html { redirect_to @text_query, notice: 'Text query was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @text_query.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /text_queries/1
  # DELETE /text_queries/1.json
  def destroy
    @text_query = TextQuery.find(params[:id])
    @text_query.destroy

    respond_to do |format|
      format.html { redirect_to text_queries_url }
      format.json { head :no_content }
    end
  end
end
