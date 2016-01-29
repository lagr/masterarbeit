module WorkflowEngine
  class ServerManager
    def initialize(engine)
      @engine = engine
      @sender = engine.sender
    end

    def prepare(server:)
    end

    def adapt(server:)
    end

    private

    def get_configuration(server)
    end
  end
end
