class ModerationController < ApplicationController
    include AppHelper
    include ModerationHelper

    before_action :verify_user
    before_action :is_mod, except: [:set_admin, :mod_view_uid]

    def is_mod
        @user = User.where(:hash => cookies[:hash]).first
        unless @user.admin
            redirect_to action: :no_content, controller: :app
        end
    end
    def verify_user
        @user = User.where(:hash => cookies[:hash])
        if !@user.any? || (@user.first.ip != request.remote_ip)
            redirect_to action: :no_content, controller: :app # replace with not authorized
        end
        @user = @user.first
        if @user.banned
          redirect_to controller: :app, action: :banned
        end
    end

    def ban_post
        @user = User.where(:hash => params[:hash])
        if @user.any?
            @user = @user.first
            @user.banned = true
            SaveUser(@user)
        end
    end
    def delete_post_post
        @post = Post.find(params[:id])
        if @post != nil
            @post.destroy
        end
        if params[:modview]
            redirect_to action: :mod_view
        else
            redirect_to action: :index, controller: :app
        end
    end
    def set_admin
        if request.remote_ip == "127.0.0.1"
            @user = User.where(:hash => params[:hash])
            if @user.any?
                @user = @user.first
                @user.admin = true
                SaveUser(@user)
                redirect_to controller: "app", action: "index"
            end
        end
    end
    def approve_post_post
        @post = Post.find(params[:id])
        @post.held = false
        @post.save
        redirect_back(fallback_location: 'app#index')
    end
    def deny_post_post
        delete_post_post
        redirect_back(fallback_location: 'app#index')
    end

    def mod_view
        @posts = Post.where(:held => false)
    end

    def mod_view_uid
      @user = User.where(:hash => cookies[:hash]).first
      # puts "AAAAA #{@user.id.class} #{params[:id].class}"
      if @user.admin || (@user.id == params[:id].to_i)
        @posts = Post.where(user_id: params[:id])
      else
        redirect_to controller: "app", action: "no_content"
      end
    end

    def mod_view_held
        @posts = Post.where(:held => true)
    end
    def hold_post_post
        @post = Post.find(params[:id])
        if @post.held
            @post.held = false
        else
            @post.held = true
        end
        @post.save
        redirect_back(fallback_location: 'app#index')
    end
    def edit_error
    end
    def edit
        @post = Post.find(params[:pid])
        unless @post.changelog
            redirect_to action: :edit_error
        end
    end
    def edit_post
        @post = Post.find(params[:id])
        if params[:image]
            @post.image.attach(params[:image])
        end
        @post.content = params[:content]
        @post.save
        if @post.changelog
            redirect_to action: :changelogs_scroll, controller: :app, id: @post.id
        else
            redirect_to action: :view_post, controller: :app, id: @post.id
        end
    end
end
