require 'hutch'

module Activity
  class WorklistItem
    attr_accessor :data

    def initialize(configuration)
      Hutch::Config.tap do |c|
        c.set :mq_host,     'wfms_mom_1'
        c.set :mq_api_host, 'wfms_mom_1'
        c.set :mq_exchange, 'wfms'
      end
      Hutch.connect

      @rabbit_connection = Bunny.new(host: 'wfms_mom_1')
      @rabbit_connection.start
      @channel = @rabbit_connection.create_channel
      @topic = @channel.topic('wfms', durable: true)
      @configuration = configuration
      @item = {}
    end

    def expose
      @item = create_worklist_item
      wait_for_completion
      delete_worklist_item
    end

    def data
      @item['data']
    end

    private
    def create_worklist_item
      created_queue = new_response_queue("wfms.worklist_item.created")
      Hutch.publish "wfms.worklist_item.create", {
        user_id: @configuration['user_id'],
        config: @configuration,
        activity_instance_id: Activity::Configuration.activity_instance_id,
        workflow_instance_id: Activity::Configuration.workflow_instance_id
      }

      get_response(created_queue)
    end

    def wait_for_completion
      finished_queue = new_response_queue("wfms.worklist_item.updated")
      @item = get_response(finished_queue)
    end

    def delete_worklist_item
      deleted_queue = new_response_queue("wfms.worklist_item.destroyed")
      Hutch.publish "wfms.worklist_item.destroy", id: @item['id']
      get_response(deleted_queue)
    end

    def new_response_queue(key)
      response_queue = @channel.queue("", :exclusive => true)
      response_queue.bind(@topic, routing_key: key)
      response_queue
    end

    def get_response(queue)
      @response_object = nil

      begin
        queue.subscribe(:block => true) do |delivery_info, properties, body|
          @response_object = JSON.parse(body)['worklist_item']
          if !@response_object.nil? && (@item['id'] == nil || @item['id'] == @response_object['id'])
            delivery_info.consumer.cancel
          end
        end
      ensure
        queue.delete
      end

      @response_object
    end
  end
end
