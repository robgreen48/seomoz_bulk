class WhitelistUrlsController < ApplicationController
  before_action :set_whitelist_url, only: [:show, :edit, :update, :destroy]

  # GET /whitelist_urls
  # GET /whitelist_urls.json
  def index
    @whitelist_urls = WhitelistUrl.all
  end

  # GET /whitelist_urls/1
  # GET /whitelist_urls/1.json
  def show
  end

  # GET /whitelist_urls/new
  def new
    @whitelist_url = WhitelistUrl.new
  end

  # GET /whitelist_urls/1/edit
  def edit
  end

  # POST /whitelist_urls
  # POST /whitelist_urls.json
  def create
    @whitelist_url = WhitelistUrl.new(whitelist_url_params)

    respond_to do |format|
      if @whitelist_url.save
        format.html { redirect_to @whitelist_url, notice: 'Whitelist url was successfully created.' }
        format.json { render action: 'show', status: :created, location: @whitelist_url }
      else
        format.html { render action: 'new' }
        format.json { render json: @whitelist_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /whitelist_urls/1
  # PATCH/PUT /whitelist_urls/1.json
  def update
    respond_to do |format|
      if @whitelist_url.update(whitelist_url_params)
        format.html { redirect_to @whitelist_url, notice: 'Whitelist url was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @whitelist_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /whitelist_urls/1
  # DELETE /whitelist_urls/1.json
  def destroy
    @whitelist_url.destroy
    respond_to do |format|
      format.html { redirect_to whitelist_urls_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_whitelist_url
      @whitelist_url = WhitelistUrl.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def whitelist_url_params
      params.require(:whitelist_url).permit(:domain)
    end
end
