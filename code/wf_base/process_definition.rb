module Workflow
  class ProcessDefinition
    attr_accessor :activities

    Activity = Struct.new(:id, :type, :successors, :predecessors)

    def initialize
      file = File.read(Workflow::Configuration.process_definition)
      @definition = JSON.parse(file)

      @activities = @definition['activities'].map do |a|
        Activity.new(a['id'], a['type'], a['successors'], a['predecessors'])
      end

      # replace list of ids with references to objects
      @activities.each do |activity|
        activity.successors = activity.successors.map do |successor_id|
          @activities.find { |a| a.id == successor_id }
        end

        activity.predecessors = activity.predecessors.map do |predecessor_id|
          @activities.find { |a| a.id == predecessor_id }
        end
      end
    end
  end
end
