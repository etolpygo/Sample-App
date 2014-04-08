Cs232demo::Application.routes.draw do
  
  # resources :microposts
  # resources :users

  root  'static_pages#home'
  
  get "users/new"
  match '/signup',  to: 'users#new',            via: 'get'
  
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/links',   to: 'static_pages#links',   via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'
  
end
