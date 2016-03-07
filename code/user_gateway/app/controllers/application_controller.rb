class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def initialize
    ApplicationController.initialize_rabbitmq
  end

  def self.initialize_rabbitmq
    @rabbit_connection = Bunny.new(host: 'wfms_mom_1')
    @rabbit_connection.start
    @channel = @rabbit_connection.create_channel
    @topic = @channel.topic('wfms', durable: true)
  end

  def self.channel
    @channel
  end

  def self.topic
    @topic
  end

  def mq_request(key, response_key, payload)
    rq = new_response_queue("wfms.#{response_key}")
    Hutch.publish "wfms.#{key}", payload
    get_response(rq)
  end

  def new_response_queue(key)
    response_queue = ApplicationController.channel.queue("", :exclusive => true)
    response_queue.bind(ApplicationController.topic, routing_key: key)
    response_queue
  end

  def get_response(queue, timeout=10)
    @response_object = nil
    begin
      Timeout::timeout(timeout) do
        queue.subscribe(:block => true) do |delivery_info, properties, body|
          @response_object = JSON.parse(body)
          delivery_info.consumer.cancel
        end
      end
    ensure
      queue.delete
    end
    @response_object
  end
end
