class OrSplitElement < ActiveRecord::Base
  include HasOnePredecessor
  include HasManySuccessors
  include IsProcessElement
end
