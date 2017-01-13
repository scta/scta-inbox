Rails.application.routes.draw do
   root 'notifications#temp'
   resources :notifications
   match '/notifications' => "notifications#options", via: :options

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
