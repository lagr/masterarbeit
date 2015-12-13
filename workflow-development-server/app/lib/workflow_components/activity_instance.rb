require 'aasm'
class Workflow::ActivityInstance
  include AASM

  attr_accessor :fiber, :activity, :completed_predecessors, :state

  def initialize(activity)
    @activity = activity
    @fiber = activity_fiber(activity)
  end

  def return_control
    Fiber.yield(aasm.current_state)
  end

  def update_state(*args)
    @fiber.resume(*args)
  end

  def activity_fiber(activity)
    Fiber.new do
      completed_predecessors = []

      loop do
        required_predecessors_completed?(element, completed_predecessors) ? break : completed_predecessors << return_control
      end

      activate do
        element_container = create_container_for(element)
      end
      
      loop { container_stopped?(element_container) ? break : return_control }
    end
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
      transitions from: :active, to: :completed, if: :completion_conditions_met?
    end    
  end

  def log_status_change
    puts "======================================================================="
    puts "Activity #{activity.id} is now #{aasm.to_state}. Activity was #{aasm.from_state}"
  end
end
