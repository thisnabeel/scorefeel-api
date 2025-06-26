class UsersController < BaseController
  before_action :authenticate_user!, except: [:sign_in, :sign_up, :create]
  before_action :set_user, only: [:show, :update, :destroy]

  def index
    @users = User.all
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    head :no_content
  end

  def sign_up
    @user = User.new(sign_up_params)
    
    begin
      @user.save!
      render json: {
        user: UserSerializer.new(@user),
        message: "Successfully signed up"
      }, status: :created
    rescue => e
      render json: {
        errors: @user.errors.full_messages
      }, status: :unprocessable_entity
    end



  end

  def sign_in
    user = User.find_by(email: params[:email])
    
    if user&.valid_password?(params[:password])
      puts "We are fine!"
      render json: {
        user: UserSerializer.new(user),
        message: "Successfully signed in"
      }, status: :ok
    else
      render json: { 
        error: "Invalid email or password" 
      }, status: :unauthorized
    end
  end

  def current_user_info
    render json: current_user
  end

  def add_role
    @user = User.find(params[:id])
    role = params[:role]
    
    if @user.add_role(role)
      render json: {
        user: @user,
        message: "Role '#{role}' added successfully"
      }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def remove_role
    @user = User.find(params[:id])
    role = params[:role]
    
    if @user.remove_role(role)
      render json: {
        user: @user,
        message: "Role '#{role}' removed successfully"
      }
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'User not found' }, status: :not_found
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :birthdate, :timezone, roles: [])
  end

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name, :birthdate, :timezone)
  end
end 