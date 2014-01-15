class Group < ActiveRecord::Base
  has_many :rules, :dependent => :destroy
  has_many :members, :dependent => :destroy
end
