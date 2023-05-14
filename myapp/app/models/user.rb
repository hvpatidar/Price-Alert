class User < ApplicationRecord
  store_in client: :brinerds
  store_in collection: :users
  has_many :alerts
  attr_accessor :jwt_token

  def generate_jwt_token
    payload = {
      user_id: id,
      exp: 1.day.from_now.to_i
    }
    JWT.encode(payload, Rails.application.secrets.jwt_secret_key)
  end

  def self.authenticate(email, password)
    user = find_by(email: email)
    if user && user.authenticate(password)
      user.jwt_token = user.generate_jwt_token
      user
    end
  end
  
end
