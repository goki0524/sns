class Message < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :message_content, presence: true, length: {maximum: 1000}
  validates :receiver_id, presence: true
  
end
