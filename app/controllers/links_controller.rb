class LinksController < ApplicationController
  before_filter :require_user!
  before_filter :require_owner!, :only => [:edit, :update]

  def create
    @link = current_user.links.build(params[:link])
    if @link.save
      redirect_to link_url(@link)
    else
      render :new
    end
  end

  def edit
    @link = Link.find(params[:id])
  end

  def new
    @link = Link.new
  end

  def show
    @link = Link.find(params[:id])
  end

  def update
    @link = Link.find(params[:id])
    if @link.update_attributes(params[:link])
      redirect_to link_url(@link)
    else
      render :new
    end
  end

  def upvote
    @link = Link.find(params[:id])
    @user_vote = UserVote.find_by_link_id_and_user_id(@link.id,current_user.id)

    _vote(@user_vote,1)

    redirect_to @link
  end

  def downvote
    @link = Link.find(params[:id])
    @user_vote = UserVote.find_by_link_id_and_user_id(@link.id,current_user.id)

    _vote(@user_vote,-1)

    redirect_to @link
  end

  private

  def _vote(user_vote,direction)
    if user_vote

      user_vote.direction == direction ? user_vote.update_attributes(direction: 0) : user_vote.update_attributes(direction: direction)
    else
      UserVote.create(user_id: current_user.id, link_id: @link.id, direction: direction)
    end
  end

  def require_owner!
    @link = Link.find(params[:id])

    return if @link.nil?

    unless @link.owner == current_user
      render :text => "Unauthorized", :status => 403
    end
  end
end
