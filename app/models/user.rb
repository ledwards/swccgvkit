class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable, :activatable, :confirmable
  devise :database_authenticatable, :registerable, :encryptable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation

  has_and_belongs_to_many :roles
  has_many :cardlists

  def has_role?(role)
    return self.roles.include?(Role.find_by_name role)
  end
end
