require 'pry'

class Review < ActiveRecord::Base
  belongs_to :reservation
  #belongs_to :listing
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validates :reservation, presence: true
  validate :invalid_without_reservation
  validate :reservation_must_be_accepted
  validate :checked_out

  private

    def invalid_without_reservation
      errors.add(:review, "must be associated with reservation") unless
        self.reservation_id
    end

    def reservation_must_be_accepted
      errors.add(:reservation, "must be accepted") unless
        if self.reservation_id
          Reservation.find(self.reservation_id).status === "accepted"
        end
    end

    def checked_out
      errors.add(:reservation, "must be past checkout") unless
        if self.reservation_id
          Date.today > Reservation.find(self.reservation_id).checkout
        end
    end

end
