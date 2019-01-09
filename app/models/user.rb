class User < ApplicationRecord
  has_one :profile, dependent: :destroy
  has_many :to_do_lists, dependent: :destroy
  has_many :to_do_items, through: :to_do_lists, source: :to_do_items

  validates :username, presence: true


  def get_completed_count
    to_do_items.where(completed: true).length
  end
end
