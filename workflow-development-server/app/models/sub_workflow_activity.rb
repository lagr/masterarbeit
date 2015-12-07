class SubWorkflowActivity < ActiveRecord::Base
  include IsPartOfProcess

  belongs_to :sub_workflow, class_name: 'Workflow'
end
