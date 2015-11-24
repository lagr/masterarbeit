class ControlFlowSerializer < ActiveModel::Serializer
  attributes :id, :predecessor, :successor
end
