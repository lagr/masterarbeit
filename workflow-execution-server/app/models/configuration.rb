class Configuration < ActiveRecord::Base
  store_accessor :settings
  scope :current, ->{ where(current: true).first }
end
