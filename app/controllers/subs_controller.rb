class SubsController < ApplicationController
  before_filter :require_user!
  before_filter :require_moderator!, :only => [:edit, :update]

  def create
    begin
      ActiveRecord::Base.transaction do
        @sub = current_user.subs.build(name: params[:sub][:name])

        @links = params[:sub][:links_attributes].map do |_,link_params|
          Link.new(link_params)
        end

        @links.reject! { |link| link.url.empty? }

        @sub.save

        @links.each do |link|
          link.subs << @sub
          link.save
        end

        raise "invalid" unless @sub.valid? && @links.all? { |link| link.valid? }
      end

    rescue
      flash[:errors] = @sub.errors.full_messages
      redirect_to new_sub_url
    else
      redirect_to sub_url(@sub)
    end
  end

  def edit
    @sub = Sub.find(params[:id])
  end

  def index
    @subs = Sub.all
    render :index
  end

  def new
    @sub = Sub.new
    5.times { @sub.links.build }
  end

  def show
    @sub = Sub.find(params[:id])
  end

  def update
    @sub = Sub.find(params[:id])
    if @sub.update_attributes(params[:sub])
      redirect_to sub_url(@sub)
    else
      render :edit
    end
  end

  private
  def correct_user!
    @sub = Sub.find(params[:id])
    redirect_to root_url unless @sub.moderator == current_user
  end

  def require_moderator!
    @sub = Sub.find(params[:id])

    return if @sub.nil?
    unless @sub.moderator == current_user
      render :text => "Unauthorized", :status => 403
    end
  end
end
