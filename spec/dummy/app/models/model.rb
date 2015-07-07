require "#{Rails.root}/lib/boolean_validator"

class Model < ActiveRecord::Base
  validates :str, :txt, :bol,
    presence: true

  validates :int,
    numericality: {
      message: 'number only'
    }

  validates :bol,
    boolean: true

  validate :validate_str

  def validate_str
    errors.add(:str, :validate_str) if str == '失敗する'
  end
end
