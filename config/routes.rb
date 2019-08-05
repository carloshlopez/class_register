Rails.application.routes.draw do
  resources :student_records
  resources :classroom_registers
  resources :students
  resources :chapters
  resources :teachers
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
