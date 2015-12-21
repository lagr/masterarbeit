class Event < ActiveRecord::Base
  store_accessor :data

  belongs_to :subject, polymorphic: true
end
