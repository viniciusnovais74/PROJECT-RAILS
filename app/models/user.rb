class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  after_create :set_statistic
  has_one :user_profile
  has_one_attached :avatar
  accepts_nested_attributes_for :user_profile, reject_if: :all_blank
  

  # Validations
  validates :first_name, presence: true, length: { minimum: 3 }, on: :update, unless: :reset_password_token_present?
  
  def reset_password_token_present?
    !!$global_params[:user][:reset_password_token]
  end
  
  # Virtual Attributes
  def full_name
    [self.first_name, self.last_name].join(' ')
  end
  private
  
  def set_statistic
    AdminStatistic.set_event(AdminStatistic::EVENTS[:total_users])
  end
end
