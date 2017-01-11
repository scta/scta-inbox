class Notification < ApplicationRecord
  serialize :object, JSON
end
