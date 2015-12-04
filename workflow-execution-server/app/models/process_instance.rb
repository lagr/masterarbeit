class ProcessInstance < ActiveRecord::Base
  include AASM

  belongs_to :process_definition
  belongs_to :workflow_instance

  aasm column: :instance_state do
    after_all_transitions :log_status_change

    state :initiated, initial: true
    state :running
    state :active
    state :suspended
    state :completed
    state :terminated

    event :start do
      transitions from: :initiated, to: :running
    end

    event :restart do
      transitions from: [:running, :suspended], to: :initiated
    end

    event :suspend do
      transitions from: :running, to: :suspended
    end

    event :resume do
      transitions from: :suspended, to: :running
    end

    event :mark_as_active do
      transitions from: :running, to: :active
    end

    event :mark_as_running do
      transitions from: :active, to: :running
    end

    event :complete do
      transitions from: :running, to: :completed, if: :completion_conditions_met?
    end

    event :terminate do
      transitions from: [:suspended, :running, :active], to: :terminated
    end
  end

  def log_status_change
  end
end
