class Campaign < ApplicationRecord
  belongs_to :user
  has_one :document, inverse_of: :campaign
  has_many :posts, dependent: :destroy

  default_scope { where("deleted_at IS NULL").order("id DESC") }

  VALID_INTERVAL_TYPES =  ["seconds", "minutes", "hours", "days", "weeks", "months"]
  VALID_STATES = ["created", "in_progress", "completed"]

  QUEUE_NAME = "campaign"

  validates :name, :start_at, :interval, :interval_type,
    :document, :state, presence: true

  validates :interval, numericality: { only_integer: true, greater_than: 0 }
  validates :interval_type, inclusion: { in: VALID_INTERVAL_TYPES }
  validates :state, inclusion: { in: VALID_STATES }

  validate :document_present


  def destroy
    self.deleted_at = Time.now
    self.save(validate: false)
  end

  private

  def document_present
    return if document && document.valid?

    self.errors.add(:document, "invalid or not present")
  end

end
