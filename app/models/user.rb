class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :name, :phone
  validates :name, presence: true
  validates :phone, presence: true
  has_many :created_events, :class_name => "Event", :foreign_key => :user_id
  has_many :attendees
  has_many :attending_events, :through => :attendees, :source => :event
end
