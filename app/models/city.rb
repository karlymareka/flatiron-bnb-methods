require 'pry'

class City < ActiveRecord::Base
  has_many :neighborhoods
  has_many :listings, :through => :neighborhoods

  def city_openings(checkin, checkout)
    @city_openings = []
    self.neighborhoods.each do |neighborhood|
      neighborhood.neighborhood_openings(checkin, checkout).each do |neighborhood_opening|
        @city_openings << neighborhood_opening
      end
    end
    return @city_openings
  end

  def self.most_res
    @num_res_city = 0
    @city_most_res = nil
    self.all.each do |city|
      @reservations = []
      city.neighborhoods.each do |neighborhood|
        neighborhood.reservations.each do |reservation|
          @reservations << reservation
        end
      end
      if @reservations.count > @num_res_city
        @num_res_city = @reservations.count
        @city_most_res = city
      end
    end
    return @city_most_res
  end

  def self.highest_ratio_res_to_listings
    @highest_ratio = 0.0
    @city_highest_ratio = nil
    self.all.each do |city|
      @cur_ratio = 0.0
      @num_res_city = 0.0
      @num_list = 0.0
      @reservations = []
      @listings = []
      city.neighborhoods.each do |neighborhood|
        neighborhood.reservations.each do |reservation|
          @reservations << reservation
        end
      end
      @num_res_city = @reservations.count.to_f
      @num_list = city.listings.count.to_f
      @cur_ratio = @num_res_city/@num_list
      if @cur_ratio > @highest_ratio
        @city_highest_ratio = city
        @highest_ratio = @cur_ratio
      end
    end
    return @city_highest_ratio
  end

end
