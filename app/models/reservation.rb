require 'pry'

class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  #belongs_to :host, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :checkout_cant_be_same_as_checkin
  validate :checkin_is_before_checkout
  validate :cant_reserve_own_listing
  validate :listing_is_available

  def duration
    self.checkout - self.checkin
  end

  def total_price
    self.listing.price * (self.checkout - self.checkin)
  end

  private

  def checkout_cant_be_same_as_checkin
    errors.add(:checkin, "can't be same as checkout") unless
      self.checkin != self.checkout
  end

  def checkin_is_before_checkout
    errors.add(:checkin, "must be before checkout") unless
      if self.checkin && self.checkout
        self.checkin < self.checkout
      end
  end

  def cant_reserve_own_listing
    errors.add(:guest, "cannot be the same as host") unless
      if self.guest && self.listing.host_id
        self.guest.id != self.listing.host_id
      end
  end

  def listing_is_available
    if self.listing.reservations.count > 0
        self.listing.reservations.each do |reservation|
          if self.checkin && self.checkout
            if reservation.checkin <= self.checkout && self.checkin <= reservation.checkout
              unless self === reservation
                errors.add(:checkin, "can't conflict with another reservation")
              end 
            end
          end
        end
      end
  end

end
