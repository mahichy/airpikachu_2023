class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :omniauthable

         validates :fullname, presence: true, length: {maximum: 50}

         has_many :rooms

    def self.from_omniauth(auth)
    user = User.where(email: auth.info.email).first
    if user
      return user
    else
      # find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      where(provider: auth.provider, uid: auth.uid) do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.fullname = auth.info.name  
        user.image = auth.info.image 
        user.uid = auth.uid
        user.provider = auth.provider
        # If you are using confirmable and the provider(s) you use validate emails, 
        # uncomment the line below to skip the confirmation emails.
        # user.skip_confirmation!
      end
    end
  end
end
