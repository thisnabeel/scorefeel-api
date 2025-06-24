class BaseController < ApplicationController
  # Skip CSRF protection for API
  # skip_before_action :verify_authenticity_token
  
  # Set response format to JSON
  before_action :set_default_response_format
  
  # Handle common errors
  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :bad_request
  
  private
  
  def set_default_response_format
    request.format = :json
  end
  
  def not_found(exception)
    render json: { error: exception.message }, status: :not_found
  end
  
  def unprocessable_entity(exception)
    render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
  end
  
  def bad_request(exception)
    render json: { error: exception.message }, status: :bad_request
  end
end 