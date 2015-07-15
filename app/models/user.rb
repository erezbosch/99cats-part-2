class User < ActiveRecord::Base
  validates :user_name, :password_digest, presence: true
  validates :user_name, length: { minimum: 5 }
  validates :password, length: { minimum: 6, allow_nil: true }

  validate :ensure_session_token

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

  def reset_session_token!
    self.session_token = generate_session_token
    save!
    session_token
  end

  private

  def generate_session_token
    SecureRandom.urlsafe_base64
  end

  def ensure_session_token
    self.session_token ||= generate_session_token
  end
end
