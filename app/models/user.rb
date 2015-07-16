class User < ActiveRecord::Base
  validates :user_name, :password_digest, presence: true
  validates :user_name, length: { minimum: 5 }
  validates :password, length: { minimum: 6, allow_nil: true }

  attr_reader :password

  has_many(
    :cats,
    class_name: :Cat,
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :rental_requests,
    class_name: :CatRentalRequest,
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many(
    :session_tokens,
    class_name: :SessionToken,
    foreign_key: :user_id,
    primary_key: :id
  )

  def self.find_by_credentials(user_name, password)
    user = User.find_by(user_name: user_name)
    user && user.is_password?(password) ? user : nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end

  def create_session_token!
    session_tokens.create!(user_id: id, token: generate_session_token)
  end

  private

  def generate_session_token
    SecureRandom.urlsafe_base64
  end
end
