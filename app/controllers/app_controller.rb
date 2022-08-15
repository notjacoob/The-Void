class AppController < ApplicationController
  require 'securerandom'
  include AppHelper
  delegate :simple_format, to: 'ActionController::Base.helpers'  
  delegate :sanitize, to: 'ActionController::Base.helpers'    
  before_action :first_time_visit
  before_action :verify_user, except: [:no_content]
  before_action :is_banned, except: [:banned]

  # TODO link support (?)

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
      @posts = Post.where(changelog: false, held: false)
      @post = @posts.sample
    if @post != nil
      redirect_to action: :view_post, id: @post.id
    else
      redirect_to action: :no_content
    end
  end
  def file_size
  end
  def create_post_post
    @user = User.where(:hash => cookies[:hash]).first
    word_override = params[:word_override] == "1"&& @user.admin
    time_override = params[:time_override] == "1"&& @user.admin
    mod_marker = (params[:mod_marker] == "1" || params[:changelog] == "1") && @user.admin
    changelog = params[:changelog] == "1" && @user.admin
    if (time_override) || (DateTime.now.to_i - @user.last_post.to_i >= 30)
        if (word_override) || params[:content].split.size >= 3
          # do profanity check here (hold any slur, 25%+ profanity density)
          @post = Post.create(content: CleanText(sanitize(params[:content])), user: @user, views: 0, mod: mod_marker, changelog: changelog)
          if params[:image]
            @post.image.attach(params[:image])
          end
          if !@post.valid?
            redirect_to action: :file_size
          else
            @post.save
            @user.last_post = DateTime.now
            SaveUser(@user)
            if @post.changelog
                redirect_to action: :changelogs
            else
                redirect_to action: :view_post, id: @post.id
            end
          end
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
      if !@post.changelog
        if !@post.held || @post.user == @user
          @likes = Like.where(:post => @post).count
          @post.views = @post.views + 1
          @post.save
        else
          redirect_to action: :no_content
        end
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
  def changelogs
      @posts = Post.where(changelog: true).sort_by(&:created_at).reverse
      @scroll_to = "null"
  end
  def changelogs_scroll
      @posts = Post.where(changelog: true).sort_by(&:created_at).reverse
      @scroll_to = params[:id]
      render "changelogs"
  end
end