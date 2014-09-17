Reddit::Application.routes.draw do
  resources :links do
    resources :comments, :only => [:new, :show, :create]

    member do
      get "upvote"
      get "downvote"
    end
  end
  resource :session
  resources :subs
  resources :users
end