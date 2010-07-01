class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :lockable, :timeoutable, :activatable, :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation
  
  has_and_belongs_to_many :roles
  
  def admin?
    return self.roles.include?(Role.find_by_name "admin")
  end
  
  def card_admin?
    return self.roles.include?(Role.find_by_name "card_admin")
  end
  
  def owner?
    return self.roles.include?(Role.find_by_name "owner")
  end
end
