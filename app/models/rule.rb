class Rule < ActiveRecord::Base
  belongs_to :filter_reason
  belongs_to :group
end
