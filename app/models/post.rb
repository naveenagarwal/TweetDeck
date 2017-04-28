require 'sidekiq/api'

class Post < ApplicationRecord
  default_scope { where("deleted_at IS NULL").order("id DESC") }

  VALID_STATES = ['drafted', 'ready', 'tweeted', 'retweet_ready', 'retweeted', 'dequeued']
  EDITABLE_STATES = ['drafted', 'ready']

  belongs_to :user
  belongs_to :profile, optional: true
  belongs_to :document, optional: true
  belongs_to :campaign, optional: true

  has_many :media, class_name: Media.name, inverse_of: :post

  accepts_nested_attributes_for :media,
    reject_if: proc { |attributes| attributes['upload_doc'].blank? },
    limit: 4,
    allow_destroy: true


  validates :content, :state, presence: true
  validates :state, inclusion: { in: VALID_STATES }

  before_destroy :dequeue

  before_update :reschedule, if: :schedule_changed?

  def drafted?
    state == "drafted"
  end

  def ready?
    state == "ready"
  end

  def tweeted?
    state == "tweeted"
  end

  def retweeted?
    state == "retweeted"
  end

  def retweet_ready?
    state == "retweet_ready"
  end

  def editable?
    EDITABLE_STATES.any? { |editable_state| state == editable_state }
  end

  def schedule(profile, queue)
    return if !valid_post_to_be_scheduled? || profile.blank? || profile_mismatch?(profile)
    self.job_id = TwitterWorker.perform_at(scheduled_at, id, profile.id)
    self.queue_name = queue
    self.profile_id = profile.id
    save
  end

  def dequeue
    return if job_id.blank?
    job_dequeued = false
    queues = [ Sidekiq::ScheduledSet.new(), Sidekiq::Queue.new(queue_name) ]
    queues.each do |queue|
      queue.each do |job|
        next if job.jid != job_id
        job.delete
        job_dequeued = true
        self.job_id = nil
        self.queue_name = nil
        self.state = "dequeued"
        save
        break
      end
      break if job_dequeued
    end
  end

  def destroy
    self.deleted_at = Time.now
    self.save(validate:  false)
  end

  def reschedule
    dequeue
    schedule(Profile.find(profile_id, "default")) if profile_id.present?
  end

  def can_set_schedule_at?
    ["ready", "tweeted", "retweet_ready"].any? { |allowed_state|
      state == allowed_state
    }
  end

  private

  def schedule_changed?
    changes[:scheduled_at].present? &&
    changes[:scheduled_at].first.present? &&
    state == "ready"
  end

  def profile_mismatch?(profile)
    profile.user_id != user_id
  end

  def valid_post_to_be_scheduled?
    scheduled_at.present? && ((job_id.blank? && ready?) ||
      (scheduled_at.present? && (tweeted? || retweet_ready? )))
  end

end
