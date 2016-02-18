class WorkflowFullSerializer < ActiveModel::Serializer
  attributes :id, :name, :created_at, :updated_at
  has_one :process_definition

  class ProcessDefinitionSerializer < ActiveModel::Serializer
    attributes :id
    has_many :activities
    has_many :control_flows

    class ActivitySerializer < ActiveModel::Serializer
      attributes :id, :activity_type, :input_schema, :output_schema,
                 :activity_configuration, :representation,
                 :process_definition_id, :subworkflow_id
      has_many :outgoing_control_flows, key: :successors
      has_many :incoming_control_flows, key: :predecessors

      def outgoing_control_flows
        object.outgoing_control_flows.collect(&:successor_id)
      end

      def incoming_control_flows
        object.incoming_control_flows.collect(&:predecessor_id)
      end
    end

    class ControlFlowSerializer < ActiveModel::Serializer
      attributes :id, :successor_id, :predecessor_id
    end
  end
end
