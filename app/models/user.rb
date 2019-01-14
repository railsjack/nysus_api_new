class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,
              :registerable,
              :recoverable,
              :rememberable,
              :trackable,
              :validatable

  has_many :favorites
  has_many :establishments, through: :favorites

  has_one :establishment

  def to_label
    "#{email}"
  end
end
