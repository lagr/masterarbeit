class Server
  attr_accessor :ip, :name, :containers, :images

  def initialize(ip:, name:)
    @ip = ip
    @name = name
    @containers ||= []
    @images ||= []
  end
end
