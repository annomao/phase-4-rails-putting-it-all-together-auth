class RecipesController < ApplicationController
  before_action :require_login

  rescue_from ActiveRecord::RecordInvalid, with: :recipe_not_valid

  def index
    recipes = Recipe.all
    render json: recipes, status: :created
  end

  def create
    recipe = Recipe.create!(title:params[:title], instructions:params[:instructions], minutes_to_complete:params[:minutes_to_complete] ,user_id:session[:user_id])
    render json: recipe, status: :created
  end

  private

  def require_login
    return render json: { errors: ["Not authorized"] }, status: :unauthorized unless session.include? :user_id
  end

  def recipe_not_valid(e)
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end
end
