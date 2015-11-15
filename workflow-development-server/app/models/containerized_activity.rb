class ContainerizedActivity < ActiveRecord::Base
  include HasOnePredecessor
  include HasOneSuccessor
  include IsProcessElement
end
