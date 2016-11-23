class Notification < ApplicationRecord
  serialize :object, JSON
  serialize :target, JSON
end
