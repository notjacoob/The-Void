Rails.application.routes.draw do

  get '/', to: 'app#index'
  get '/create', to: 'app#create_post'
  get '/find', to: 'app#find_post'
  post '/create', to: 'app#create_post_post'
  get 'posts/:id', to: 'app#view_post'
  post '/like', to: 'app#like_post'
  get '/time-limit', to: 'app#time_limit'
  get '/banned', to: 'app#banned'
  get '/greater-5', to: 'app#greater_5'
  get '/file-size', to: 'app#file_size'
  get '/changelogs', to: 'app#changelogs'
  get '/edit(:id)', to: 'moderation#edit'
  post '/edit', to: 'moderation#edit_post'
  get '/edit-error', to: 'app#edit_error'
  get '/changelogs/:id', to: 'app#changelogs_scroll'

  if Rails.env.development?
    get '/set-admin/:hash', to: "moderation#set_admin"
  end

  get '/no-content', to: 'app#no_content'

  post "/ban", to: "moderation#ban_post"
  post "/delete", to: "moderation#delete_post_post"
  get '/view-posts', to: 'moderation#mod_view'
  get '/view-posts/held', to: 'moderation#mod_view_held'
  get '/view-posts/uid', to: 'moderation#mod_view_uid'
  post '/approve-post', to: 'moderation#approve_post_post'
  post '/deny-post', to: 'moderation#deny_post_post'
  post '/hold-for-review', to: 'moderation#hold_post_post'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
