class AddToDoListToToDoItem < ActiveRecord::Migration[5.2]
  def change
    add_reference :to_do_items, :to_do_list, foreign_key: true
  end
end
