class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, presence: true
  validates :last_name, presence: true
  # validates :timezone, presence: true
  # validates :roles, presence: true

  scope :by_role, ->(role) { where("roles @> ?", [role].to_json) }
  scope :admins, -> { by_role('admin') }

  def full_name
    "#{first_name} #{last_name}".strip
  end

  def admin?
    roles.include?('admin')
  end

  def has_role?(role)
    roles.include?(role.to_s)
  end

  def add_role(role)
    roles << role.to_s unless roles.include?(role.to_s)
    save!
  end

  def remove_role(role)
    roles.delete(role.to_s)
    save!
  end

  def age
    return nil unless birthdate.present?
    
    today = Date.current
    age = today.year - birthdate.year
    age -= 1 if today < birthdate + age.years
    age
  end
end
