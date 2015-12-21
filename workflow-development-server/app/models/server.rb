class Server < ActiveRecord::Base
  validates_presence_of :ip, :execution_environment_port, :docker_port
  has_and_belongs_to_many :workflow_bundles
  has_many :workflows, through: :workflow_bundles

  DEFAULT_REQUIRED_IMAGES = [
    { name: 'alpine:3.2' }
  ].freeze

  scope :repositories,      ->{ where(role: 'repository') }
  scope :execution_servers, ->{ where(role: 'execution') }

  delegate :ping?, to: :connection
  delegate :reachable?, to: :connection
  # delegate :installed_images, to: :connection
  # delegate :running_containers, to: :connection
  # delegate :execution_environment_avaliable?, to: :connection

  def required_images
    DEFAULT_REQUIRED_IMAGES + workflow_bundles.map(&:required_images).flatten.collect { |image| { name: image } }
  end

  private

  def connection
    @connection ||= ExecutionServerConnector.new(self)
  end
end
