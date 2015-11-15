class ActivityInstance < ActiveRecord::Base
  include AASM

  aasm column: :instance_state do
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
  end
end
