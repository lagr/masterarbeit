class Server < ActiveRecord::Base
  validates_presence_of :ip
  has_and_belongs_to_many :workflows

  def required_images
    workflows.map(&:required_images).flatten.collect{ |i| { name: i } }
  end

  private

  def connection
    #@connection ||= ServerConnector.new(self)
  end
end
