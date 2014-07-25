class BlacklistUrlsController < ApplicationController
  before_action :set_blacklist_url, only: [:show, :edit, :update, :destroy]

  # GET /blacklist_urls
  # GET /blacklist_urls.json
  def index
    @blacklist_urls = BlacklistUrl.all
  end

  # GET /blacklist_urls/1
  # GET /blacklist_urls/1.json
  def show
  end

  # GET /blacklist_urls/new
  def new
    @blacklist_url = BlacklistUrl.new
  end

  # GET /blacklist_urls/1/edit
  def edit
  end

  # POST /blacklist_urls
  # POST /blacklist_urls.json
  def create
    @blacklist_url = BlacklistUrl.new(blacklist_url_params)

    respond_to do |format|
      if @blacklist_url.save
        format.html { redirect_to @blacklist_url, notice: 'Blacklist url was successfully created.' }
        format.json { render action: 'show', status: :created, location: @blacklist_url }
      else
        format.html { render action: 'new' }
        format.json { render json: @blacklist_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /blacklist_urls/1
  # PATCH/PUT /blacklist_urls/1.json
  def update
    respond_to do |format|
      if @blacklist_url.update(blacklist_url_params)
        format.html { redirect_to @blacklist_url, notice: 'Blacklist url was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @blacklist_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /blacklist_urls/1
  # DELETE /blacklist_urls/1.json
  def destroy
    @blacklist_url.destroy
    respond_to do |format|
      format.html { redirect_to blacklist_urls_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_blacklist_url
      @blacklist_url = BlacklistUrl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def blacklist_url_params
      params.require(:blacklist_url).permit(:domain)
    end
end
