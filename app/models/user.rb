class User < ApplicationRecord
  has_many :partygoers
  has_many :parties, through: :partygoers

  validates :user_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password_digest, presence: true

  has_secure_password

  def invitees
    User.where.not(id: id)
  end
end
