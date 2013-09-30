# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  attr_accessor :old_password   # Virtual attributes
  attr_accessible :name, :email, :password, :password_confirmation, :old_password
  has_secure_password
  has_many  :microposts, dependent: :destroy

  before_save { email.downcase! }     #{|user| user.email = email.downcase}
  before_save :create_remember_token

  # Валидация имени
  validates	:name,	presence: true,
  									length: { maximum: 50 }
	
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	# Валидация email
  validates :email, presence: true,
  									format: { with: VALID_EMAIL_REGEX },
  									uniqueness: { case_sensitive: false }
	
	# Валидация пароля
	validates	:password, length: { minimum: 6 }
	validates	:password_confirmation, presence: true

  def feed
    Micropost.where("user_id = ?", id)    
  end

  private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end

end
