  class WorkflowVersion < ActiveRecord::Base
    belongs_to :workflow
    has_and_belongs_to_many :workflow_bundles
    has_many :workflow_elements

    #validate :at_least_one_start_element
    #validate :at_least_one_end_element

    private

    def at_least_one_start_element
      errors.add(:start_elements, 'must have at least one start element')
    end

    def at_least_one_end_element
      errors.add(:end_elements, 'must have at least one end element')
    end
  end
