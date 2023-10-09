class Entity < ApplicationRecord
  has_many :loans

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :naics_code, presence: true, length: {is: 6}
end
