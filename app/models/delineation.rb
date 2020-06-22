class Delineation < ApplicationRecord
  validates :p_waves, presence: true, numericality: true
  validates :qrs, presence: true, numericality: true
  validates :mean_rate, presence: true, numericality: true
  validates :min_heart_rate, presence: true, numericality: true
  validates :max_heart_rate, presence: true, numericality: true
  validates :time_min_rate, presence: true
  validates :time_max_rate, presence: true
  validates :day, presence: true
end
