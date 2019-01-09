class ToDoList < ApplicationRecord
  belongs_to :user
  has_many :to_do_items, dependent: :destroy

  default_scope { order :list_due_date }
end
