class EndElement < ActiveRecord::Base
  include HasOnePredecessor
  include IsProcessElement
end
