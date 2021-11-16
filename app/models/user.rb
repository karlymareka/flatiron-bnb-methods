require 'pry'

class User < ActiveRecord::Base
  has_many :listings, :foreign_key => 'host_id'
  #has_many :reservations, :foreign_key => 'guest_id'
  has_many :reservations, :through => :listings
  has_many :trips, :foreign_key => 'guest_id', :class_name => "Reservation"
  has_many :reviews, :foreign_key => 'guest_id'

  def guests
      @guests = []
      self.listings.each do |listing|
        listing.reservations.each do |reservation|
          @guests << User.find(reservation.guest_id)
        end
      end
      return @guests
  end

  def hosts
    @hosts = []
    self.trips.each do |trip|
      @listing = Listing.find(trip.listing_id)
      @hosts << User.find(@listing.host_id)
    end
    return @hosts
  end

  def host_reviews
    @reviews = []
    self.listings.each do |listing|
        #insert another iteration with reviews here
        listing.reviews.each do |review|
          @reviews << review
        end
    end
    return @reviews
  end

end
