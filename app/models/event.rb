class Event < ActiveRecord::Base
  attr_accessible :datetime, :details, :location, :name, :user_id
  validates :datetime, presence: true
  validates :location, presence: true
  belongs_to :creator, :class_name => "User"
  has_many :attending_users, :through => :attendees, :source => :user
  has_many :attendees
end
