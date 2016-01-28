module Workflow
  class MessagingService
    attr_reader :bunny

    def initialize(mom_service_url)
      @bunny = Bunny.new(mom_service_url)
      @bunny.start
      at_exit { @bunny.stop }
    end

    def channel
      @channel ||= bunny.channel
    end

    def workflow_instances_exchange
      @workflow_instances_exchange ||=
        channel.exchange("resize-image", passive: true)
    end

  end
end
