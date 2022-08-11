class AppController < ApplicationController
  require 'securerandom'
  include AppHelper
  delegate :simple_format, to: 'ActionController::Base.helpers'  
  delegate :sanitize, to: 'ActionController::Base.helpers'    
  before_action :first_time_visit
  before_action :verify_user, except: [:no_content]
  before_action :is_banned, except: [:banned]

  def first_time_visit
    if cookies[:first_visit] != "1"
      cookies.permanent[:first_visit] = 1
      @first_visit = true
    else
      unless cookies[:first_session].blank?
        @first_visit = true
      end
    end
    @user = User.where(:ip => request.remote_ip)
    if @first_visit || !@user.any?
      unless @user.any?
        @hash = SecureRandom.hex
        suppress(StandardError) do
          @user = User.create(hash: @hash, ip: request.remote_ip, admin: false, banned: false)
        end
      end
    end
    @user = @user.first
    cookies[:hash] = @user.hash
  end

  def verify_user
    @user = User.where(:hash => cookies[:hash])
    if !@user.any? || (@user.first.ip != request.remote_ip)
      redirect_to action: :no_content # replace with not authorized
    end
  end

  def is_banned
    @user = User.where(:hash => cookies[:hash]).first
    if @user.banned
      redirect_to action: :banned
    end
  end

  def index
  end
  def create_post
    @user = User.where(:hash => cookies[:hash]).first
  end
  def find_post
    @ids = Post.pluck(:id)
    @id = @ids.sample
    if @id != nil
      redirect_to action: :view_post, id: @ids.sample
    else
      redirect_to action: :no_content
    end
  end
  def create_post_post
    @user = User.where(:hash => cookies[:hash]).first
      if (@user.admin && params[:mod_override] == 1) || (DateTime.now.to_i - @user.last_post.to_i >= 60)
        if (@user.admin && params[:mod_override] == 1) || params[:content].split.size > 5
          # do profanity check here (holy any slur, 25%+ profanity density)
          @post = Post.create(content: CleanText(sanitize(params[:content])), user: @user, views: 0)
          @post.image.attach(params[:image])
          @user.last_post = DateTime.now
          SaveUser(@user)
          redirect_to action: :view_post, id: @post.id
        else
          redirect_to action: :greater_5
        end
      else
        redirect_to action: :time_limit
      end
  end
  def time_limit
  end
  def view_post
    begin
      @user = User.where(:hash => cookies[:hash]).first
      @post = Post.find(params[:id])
      if !@post.held || @post.user == @user
        @likes = Like.where(:post => @post).count
        @post.views = @post.views + 1
        @post.save
      else
        redirect_to action: :no_content
      end
    rescue
      redirect_to action: :no_content
    end
  end
  def no_content
  end
  def like_post
    @post = Post.find(params[:id])
    @user = User.where(:hash => cookies[:hash]).first
    if !HasUserLiked()
      @like = Like.create(:user => @user, :post => @post)
      redirect_to action: :view_post, id: @post.id
    else
      @like = Like.where(:user => @user, :post => @post).first
      @like.destroy
      redirect_to action: :view_post, id: @post.id
    end
  end
  def banned
    unless @user.first.banned
      redirect_to :no_content
    end
  end
  def greater_5
  end
end
