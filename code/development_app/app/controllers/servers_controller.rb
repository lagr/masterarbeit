class ServersController < ApplicationController
  before_action :set_server, only: [:show, :edit, :update, :destroy]

  # GET /servers
  # GET /servers.json
  def index
    @servers = Server.all
    @unmanaged_servers = EnvironmentManager.unmanaged_servers(@servers)
  end

  # GET /servers/1
  # GET /servers/1.json
  def show
    @required_images = [{ name: 'alpine', version: 'latest' }, { name: 'alpineee', version: 'latest' }] #@server.required_images
    @installed_images = EnvironmentManager.index_images(@server)
    merge_required_and_installed_images
  end

  # GET /servers/new
  def new
    @server = Server.new ip: params[:ip], name: params[:name]
  end

  # GET /servers/1/edit
  def edit
  end

  # POST /servers
  # POST /servers.json
  def create
    @server = Server.new(server_params)

    respond_to do |format|
      if @server.save
        MessageService.publish :server, :add, server: ActiveModel::SerializableResource.new(@server).serializable_hash

        format.html { redirect_to @server, notice: 'Server was successfully created.' }
        format.json { render :show, status: :created, location: @server }
      else
        format.html { render :new }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /servers/1
  # PATCH/PUT /servers/1.json
  def update
    respond_to do |format|
      if @server.update(server_params)
        MessageService.publish :server, :update, server_config: server_config
        format.html { redirect_to @server, notice: 'Server was successfully updated.' }
        format.json { render :show, status: :ok, location: @server }
      else
        format.html { render :edit }
        format.json { render json: @server.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /servers/1
  # DELETE /servers/1.json
  def destroy
    @server.destroy
    respond_to do |format|
      format.html { redirect_to servers_url, notice: 'Server was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def merge_required_and_installed_images
      @images = @installed_images.map do |installed_image|
        repo_tag = installed_image.info['RepoTags'].first.split("/").last.split(':')
        {
          name: repo_tag.first,
          version: repo_tag.last,
          installed: true
        }
      end

      @required_images.each do |required_image|
        required_image[:required] = true

        installed_image = @images.find do |i|
          required_image[:name] == i[:name] && required_image[:version] == i[:version]
        end

        if installed_image.nil?
          @images << required_image
          required_image[:installed] = false
        end

        installed_image = nil
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_server
      @server = Server.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def server_params
      params.require(:server).permit(:name, :ip)
    end

    def server_config
      ActiveModel::SerializableResource.new(server, serializer: ServerConfigurationSerializer).serializable_hash
    end
end
