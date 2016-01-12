require 'awesome_print'
module Workflow
  class ProcessDefinition
    Activity = Struct.new(:id, :type, :successors, :predecessors)

    attr_accessor :activities
    def initialize(definition_path:)
      begin
        file = File.read(definition_path)
        @definition = JSON.parse(file)
      rescue
        puts "file doesnt exist: #{definition_path}"
        @definition = { 'activities' => [
          { 
            'id' => "bdb17d3a-5b0b-42d6-9fbd-8b20355ec3f2", 'type' => "StartActivity",
            'successors' => ["48fb9ab9-f0ce-44d2-8999-a198075470b2"]
          },
          { 
            'id' => "48fb9ab9-f0ce-44d2-8999-a198075470b2", 'type' => "AndSplit",
            'successors' => ["c6c8859f-37c8-4219-b379-76b5b3fcfe5b", "a58743cf-9ed9-4b8d-8eef-9fa03497b977"]
          },
          { 
            'id' => "c6c8859f-37c8-4219-b379-76b5b3fcfe5b", 'type' => "AutomaticActivity1",
            'successors' => ["f8f75718-2229-4b63-9c9a-0cc5922803ba"]
          },
          { 
            'id' => "a58743cf-9ed9-4b8d-8eef-9fa03497b977", 'type' => "AutomaticActivity2",
            'successors' => ["f8f75718-2229-4b63-9c9a-0cc5922803ba"]
          },
          { 
            'id' => "f8f75718-2229-4b63-9c9a-0cc5922803ba", 'type' => "AndJoin",
            'successors' => ["97d5d5bd-e14d-49a7-af90-c8ce90495b46"]
          },
          { 
            'id' => "97d5d5bd-e14d-49a7-af90-c8ce90495b46", 'type' => "EndActivity",
            'successors' => []
          }
        ]}
        @definition = { 'activities' => [
          { 
            'id' => "cad62eb7-0170-4241-a8e7-34d719c7bdd6", 'type' => "EndActivity",
            'successors' => []
          }]}
      end

      @activities = []

      @definition['activities'].each do |activity|
        @activities << Activity.new(activity['id'], activity['type'], [], [])
      end

      @definition['activities'].each do |activity_hash|
        activity_hash['successors'].each do |successor_id|
          successor = @activities.find { |a| a.id == successor_id }
          activity = @activities.find { |a| a.id == activity_hash['id'] }
          activity.successors << successor
          successor.predecessors << activity
        end
      end
    end
  end
end
