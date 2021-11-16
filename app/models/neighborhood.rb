require 'pry'

class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings
  has_many :reservations, through: :listings

  def neighborhood_openings(checkin, checkout)
    @available_listings = []
    self.listings.each do |listing|
      @overlapping_res = []
      listing.reservations.each do |reservation|
        if reservation.checkin <= DateTime.parse(checkout) && DateTime.parse(checkin) <= reservation.checkout
          @overlapping_res << reservation
        end
      end
      if @overlapping_res.count < 1
        @available_listings << listing
      end
    end
    return @available_listings
  end

  def self.most_res
    @@neighborhood_most_res = nil
    @@num_res_current_neighborhood = 0
    self.all.each do |neighborhood|
      if neighborhood.reservations.count > @@num_res_current_neighborhood
        @@num_res_current_neighborhood = neighborhood.reservations.count
        @@neighborhood_most_res = neighborhood
      end
    end
    return @@neighborhood_most_res
  end

  def self.highest_ratio_res_to_listings
    @@neighborhood_most_res_to_listings = nil
    @@highest_ratio = 0
    self.all.each do |neighborhood|
      @num_res = neighborhood.reservations.count
      @num_list = neighborhood.listings.count
      if @num_list != 0
        @ratio = @num_res/@num_list
        if @ratio > @@highest_ratio
          @@highest_ratio = @ratio
          @@neighborhood_most_res_to_listings = neighborhood
        end
      end
    end
    return @@neighborhood_most_res_to_listings
  end

end
