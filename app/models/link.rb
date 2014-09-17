class Link < ActiveRecord::Base
  attr_accessible :url, :sub_ids, :body, :title

  has_many :comments
  belongs_to :owner, :class_name => "User"
  has_many :link_posts
  has_many :subs, :through => :link_posts
  has_many :user_votes

  before_destroy :cleanup

  validates :url, :presence => true

  def comments_by_parent
    comments_by_parent = Hash.new { |hash, key| hash[key] = [] }
    comments.each do |comment|
      comments_by_parent[comment.parent_comment_id] << comment
    end

    comments_by_parent
  end

  def votes
    votes_hash = self.user_votes.group(:direction).count
    up = votes_hash[1] || 0
    down = votes_hash[-1] || 0

    up - down
  end

  private
  def cleanup
    link_posts.each do |lp|
      # optimization to more quickly drop LinkPosts
      lp.link = nil
      lp.destroy
    end
  end
end
