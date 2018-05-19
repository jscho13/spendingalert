class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_one :subscription, ->(sub) { where.not(stripe_id: nil) }, class_name: "Payola::Subscription", foreign_key: :owner_id
end
