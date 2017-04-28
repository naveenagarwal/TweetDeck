class Profile < ApplicationRecord

  VALID_INTERVAL_TYPES =  ["minutes", "hours", "days", "weeks", "months"]

  belongs_to :user
  has_many :posts

  validates :provider, :token, :secret, presence: true

  validates :provider, uniqueness: {
              scope: :user_id,
              message: "Already signed up"
            }

  validates :default_interval, numericality: { only_integer: true, greater_than: 0 }, allow_blank: true
  validates :default_interval_type, inclusion: { in: VALID_INTERVAL_TYPES }, allow_blank: true

  validate :interval_fields

  def default_iterval_present?
    default_interval.present? && default_interval_type.present?
  end

  def default_time_from_now
    Time.now.localtime + default_interval.send(default_interval_type)
  end

  private

  def interval_fields
    return if default_interval.blank? && default_interval_type.blank?

    self.errors.add(:default_interval, "Can't be blank") if default_interval.blank?
    self.errors.add(:default_interval_type, "Can't be blank") if default_interval_type.blank?
  end

end
