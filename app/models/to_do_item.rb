class ToDoItem < ApplicationRecord
  belongs_to :to_do_list
  default_scope { order :due_date }
end
