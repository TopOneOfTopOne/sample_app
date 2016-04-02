Rails.application.routes.draw do

  root 'static_pages#home'
  get 'signup' =>'users#new'
  get 'home' => 'static_pages#home'
  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'

  resources :microposts, only: [:create, :destroy]
  resources :users do # provides standard mappings to controllers
    member do
      get 'following', 'followers' # maps to following and followers action in controller and gives users/:id/following, users/:id/followers routes
    end
  end

  resources :relationships, only: [:create, :destroy]

end
