class Sub < ActiveRecord::Base
  attr_accessible :name

  belongs_to :moderator, :class_name => "User"
  has_many :link_posts, :dependent => :destroy
  has_many :links, :through => :link_posts

  validates :name, :moderator, :presence => true
end
