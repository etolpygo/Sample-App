class Micropost < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  
  validates_presence_of :content 
end
