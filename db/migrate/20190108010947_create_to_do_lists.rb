class CreateToDoLists < ActiveRecord::Migration[5.2]
  def change
    create_table :to_do_lists do |t|
      t.string :list_name
      t.date :list_due_date

      t.timestamps
    end
  end
end
