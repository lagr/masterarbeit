module Workflow
  class ProcessDefinition
    attr_accessor :activities

    Activity = Struct.new(:id, :type, :successors, :predecessors)

    def initialize
      file = File.read(Workflow::Configuration.process_definition)
      @definition = JSON.parse(file)
      @activities = @definition['activities'].map { |a| Activity.new(a['id'], a['type'], a['successors'], a['predecessors']) }

      # replace list of ids with references to objects
      @activities.each do |activity|
        activity.successors = activity.successors.map { |s_id| @activities.find { |a| a.id == s_id } }
        activity.predecessors = activity.predecessors.map { |p_id| @activities.find { |a| a.id == p_id } }
      end
    end
  end
end
