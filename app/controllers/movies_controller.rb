class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    @movies = Movie.with_ratings(ratings_list, sort_by)

    @sort_by = sort_by
    session[:ratings] = ratings_list
    session[:sort_by] = @sort_by

    @ratings_to_show = ratings_hash
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date, :ratings, :sort_by)
  end



  #The idea of using private methods and || statements to enable session tracking came from office hours!
  
  def ratings_list
    params[:ratings]&.keys || session[:ratings]
  end
  
  def sort_by
    params[:sort_by] || session[:sort_by]
  end

  def ratings_hash
    Hash[ratings_list.collect { |mov| [mov, "1"] }]
  end



  #the implementation for an empty_redirect method is from SaaSbook forum
  #this made it easier to handle empty ratings parameters, in a way sort of similar to python
  def empty_redirect
    if !params.key?(:ratings)
      flash.keep
      url = movies_path(sort_by: sort_by, ratings: ratings_hash)
      redirect_to url
    end
  end

end
