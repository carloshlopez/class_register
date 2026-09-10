Rails.application.routes.draw do
  # The app had no root route, so "/" raised a routing error in production.
  # Chapters are the hub of the domain, so they serve as the landing page.
  # Change this if you'd rather land somewhere else.
  root "chapters#index"

  resources :student_records
  resources :classroom_registers
  resources :students
  resources :chapters
  resources :teachers

  namespace :api do
    namespace :v1 do
      resources :classroom_registers, only: [:index, :show, :create]
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
