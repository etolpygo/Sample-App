class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order('created_at DESC') }
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  
  # Returns microposts from the users being followed by the given user.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    #t = Micropost.arel_table
    #followed_user_ids = Relationship.where(follower_id: user.id).pluck(:followed_id)                  
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
    #where(t[:user_id].in(followed_user_ids)).or(t[:user_id].eq(":user_id"))
  end
end