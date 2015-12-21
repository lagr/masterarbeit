require 'aasm'
require 'securerandom'

module Workflow
  class ActivityInstance
    include AASM

    attr_accessor :fiber, :activity, :completed_predecessors, :state, :id

    def initialize(activity)
      @id = SecureRandom.uuid
      @logger = Workflow::Logger.new
      @activity = activity
      @completed_predecessors = []

      @logger.event({ id: @id, type: 'ActivityInstance' }, { info: "Activity #{activity.id} (#{activity.type}) is now #{aasm.current_state}." })
    end

    def all_predecessors_completed?
      return true if @activity.predecessors.empty?
      return true if @activity.type == "OrJoin" && @completed_predecessors.length > 0
      return true if @completed_predecessors.length > 0
      completed_predecessors_activity_ids = @completed_predecessors.map(&:activity).collect(&:id)
      (@activity.predecessors.collect(&:id) - completed_predecessors_activity_ids).empty?
    end

    aasm do
      after_all_transitions :log_status_change

      state :inactive
      state :active
      state :suspended
      state :completed

      event :suspend do
        transitions from: [:active, :inactive], to: :suspended
      end

      event :resume do
        transitions from: :suspended, to: :inactive
      end

      event :activate do
        transitions from: :inactive, to: :active
      end

      event :complete do
        transitions from: :active, to: :completed
      end    
    end

    def log_status_change
      @logger.event({ id: @id, type: 'ActivityInstance' }, { info: "Activity #{activity.id} is now #{aasm.to_state}. Activity was #{aasm.from_state}" })
    end
  end
end
