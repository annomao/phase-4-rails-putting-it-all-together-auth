class UsersController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :user_not_valid
rescue_from ActiveRecord::RecordNotFound, with: :user_does_not_exist

  def create
    user = User.create!(allowed_params)
    session[:user_id] = user.id
    render json: user, status: :created
  end

  def show
    user = User.find(session[:user_id])
    render json: user, status: :created
  end

  private

  def allowed_params
    params.permit(:username, :password, :password_confirmation, :image_url, :bio)
  end

  def user_not_valid(e)
    render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
  end

  def user_does_not_exist
    render json: {errors: "Unauthorized"}, status: :unauthorized
  end
end
