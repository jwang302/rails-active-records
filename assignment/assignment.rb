require_relative '../config/environment'

# Use Active Record Model methods to implement the following methods.
class Assignment
  # Insert rows in DB
  def create_user(params)
    User.new(params).save
  end

  def create_todo_list(params)
    ToDoList.new(
      list_name: params[:name],
      list_due_date: params[:due_date]
    ).save
  end

  # Retrieve paginated results from DB
  def find_all_users(offset, limit)
    User.offset(offset).order(:updated_at).limit(limit).all.to_a
  end

  def find_all_lists(offset, limit)
    ToDoList.offset(offset).limit(limit).order(list_due_date: :desc).all.to_a
  end

  # Query DB with exact match
  def find_user_by_name(username)
    User.where(username: username).to_a
  end

  def find_todo_list_by_name(name)
    ToDoList.where(list_name: name).to_a
  end

  # Get rows from DB by PK
  def get_user_by_id(id)
    User.find(id)
  end

  def get_todo_list_by_id(id)
    ToDoList.find(id)
  end

  # Update rows in DB
  def update_password(id, password_digest)
    User.find(id).update(password_digest: password_digest)
  end

  def update_list_name(id, name)
    ToDoList.find(id).update(list_name: name)
  end

  # Delete rows from DB
  def delete_user(id)
    User.find(id).destroy
  end

  def delete_todo_list(id)
    ToDoList.find(id).destroy
  end
end
