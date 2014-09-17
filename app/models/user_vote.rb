class UserVote < ActiveRecord::Base
  attr_accessible :user_id, :link_id, :direction

  belongs_to :user
  belongs_to :link
end