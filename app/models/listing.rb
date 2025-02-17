require 'pry'

class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations

  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true
  before_save :activate_host_status
  before_destroy :deactivate_host_status

  def average_review_rating
    reviews.average(:rating)
  
  end

  private

  def activate_host_status
    new_host = User.find(self.host_id)
    new_host.host = true
    new_host.save
  end

  def deactivate_host_status
    former_host = User.find(self.host_id)
    if former_host.listings.count === 1
      former_host.host = false
      former_host.save
    end
  end

end
