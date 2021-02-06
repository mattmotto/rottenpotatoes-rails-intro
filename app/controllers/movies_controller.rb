class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    puts("here")
    @ratings_to_show = ratings_to_show
    order_options = [:title, :release_date]
    @movieCSS = ""
    @releaseCSS = ""
    @movies
    if params[:sort_by]
      @sort_by = order_options[params[:sort_by].to_i]
      @movies = Movie.with_ratings(@ratings_to_show).order(@sort_by)
    else
      @movies = Movie.with_ratings(@ratings_to_show)
    end
    @all_ratings = Movie.all_ratings
    
    if @sort_by == :title
      @movieCSS = "bg-warning"
      @releaseCSS = ""
    elsif @sort_by == :release_date
      @movieCSS = ""
      @releaseCSS = "bg-warning"
    end
    
    @ratings_hash = Hash.new
    @ratings_to_show.each do |r|
      @ratings_hash[r] = 1
    end
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
  
  def ratings_to_show
    ans = params[:ratings]
    if ans
      return ans.keys
    end
    return []
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
