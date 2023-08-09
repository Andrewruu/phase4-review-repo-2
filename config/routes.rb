Rails.application.routes.draw do
  
  get '/reviews/:word', to: 'reviews#word'
  
  resources :reviews, except: [:show]
  resources :users, only: [:index, :create, :show]
  resources :movies

  # Routing logic: fallback requests for React Router.
  post '/signup', to: 'users#create'
  get '/me', to: 'users#show'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  post '/movies/reviews-years', to:'movies#release_year'

  # Leave this here to help deploy your app later!
  get "*path", to: "fallback#index", constraints: ->(req) { !req.xhr? && req.format.html? }


  
end


# Create a custom route that takes a parameter of a word. 
#In a new action, look at the word and find any reviews with the word in the review content field. 
# Once you have found any reviews that include that word, you will find the associated movies. 
#If no reviews are found that have that word in the description, render a json message that says so, including the word that was provided as the parameter, such as “‘hotdogs’ was not found in any of the reviews’”
