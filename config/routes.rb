Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1' do
      resources :users
      resources :visits
      resources :formularies
      resources :questions
      resources :answers

      match "*path", to: "wrong#wrong", via: :all
    end
  end
end
