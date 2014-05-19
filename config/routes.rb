Cs232demo::Application.routes.draw do
  
  root  'static_pages#home'
  
  resources :microposts
  
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
  
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/links',   to: 'static_pages#links',   via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  
end
