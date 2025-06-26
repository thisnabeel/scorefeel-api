class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :first_name, :last_name, :full_name, :birthdate, :timezone, :roles, :age, :admin, :created_at, :updated_at

  def admin
    object.admin?
  end
end 