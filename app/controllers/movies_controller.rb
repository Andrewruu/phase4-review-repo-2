class MoviesController < ApplicationController
    skip_before_action :authorize

    def index 
        movies = Movie.all
        render json: movies 
    end

    def show 
        movie = Movie.find_by(id: params[:id])
        render json: movie
    end

    def create 
        movie = Movie.create(movie_params)
        render json: movie, status: :created
    end

    def release_year
        year = params[:year].to_i

        # movies = Movie.all.select { |movie| movie.year <= year }
        movies = Movie.all.filter { |movie| movie.reviews.any?{movie.year <= year}}
        # movies = Movie.where("year <=?", year)
        if movies.empty?
            render json: {message: "No movies found for #{year}"}, status: :not_found
        else
            # movie_ids = movies.pluck(:id)
            # reviews = Review.where(movie_id: movie_ids)
            reviews = movies.flat_map{ |movie| movie.reviews }
            render json: reviews, status: :ok
        end
    end

    def update 
        movie = Movie.find(params[:id])
        movie.update!(movie_params)
        render json: movie, status: 202
    end

    def destroy 
        movie = Movie.find(params[:id])
        movie.destroy 
        head :no_content
    end

    private 

    def movie_params
        params.permit(:title, :genre, :year, :director, :image_url)
    end

end
