class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
  					:first_name, :last_name, :profile_name
  # attr_accessible :title, :body
	
  validates :first_name, presence: true 
  validates :last_name, presence: true 
  validates :profile_name, presence: true,
                          uniqueness: true, # see if another user exists with same profile name in our db when we save this user
                          format: {
                            with: /^[a-zA-Z0-9_-]+$/, #regular expression that makes sure it can include lower, upper case, 0-9, _ and -
                            message: "Must be formatted correctly." # must spit back same error as in test
                          }

  has_many :statuses

  def full_name
		first_name + ' ' + last_name
	end
end
