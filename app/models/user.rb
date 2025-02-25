class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :validatable, :omniauthable, :confirmable,
  :omniauth_providers => [:facebook, :google_oauth2]
  has_many :workouts
  has_many :articles
  has_many :comments

  def self.from_omniauth(auth)
  	where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
  		user.provider = auth.provider
  		user.uid = auth.uid
  		user.email = auth.info.email
  		user.password = Devise.friendly_token[0,20]
  		user.save
  	end
  end

  def name
    if !User.name.nil?
      name = username
    else
      name = self.email
    end
  end

end
