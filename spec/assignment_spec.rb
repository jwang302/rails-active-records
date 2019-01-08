# frozen_string_literal: true

require_relative '../assignment/assignment'

describe Assignment do
  subject(:assignment) { Assignment.new }

  before :all do
    $continue = true
  end

  around :each do |example|
    if $continue
      $continue = false
      example.run
      $continue = true unless example.exception
    else
      example.skip
    end
  end

  # helper method to determine if Ruby class exists as a class
  def class_exists?(class_name)
    eval(`defined?(#{class_name}) && #{class_name}.is_a?(Class)`)
  end

  # helper method to determine if two files are the same
  def files_same?(file1, file2)
    if File.size(file1) == File.size(file2)
      f1 = IO.readlines(file1)
      f2 = IO.readlines(file2)
      return (f1 - f2).empty?
    end
    false
  end

  context 'rq01' do
    context 'Generate Rails application' do
      it 'must have top level structure of a rails application' do
        expect(File.exist?('Gemfile')).to be(true)
        expect(Dir.entries('.')).to include('app', 'bin', 'config', 'db', 'lib', 'public', 'log', 'test', 'vendor')
        expect(Dir.entries('./app')).to include('assets', 'controllers', 'helpers', 'mailers', 'models', 'views')
      end
    end
  end

  context 'rq02' do
    # Test to make sure model objects exist and are ActiveRecord objects
    context 'Generate four(4) Model Classes and Properties' do
      context 'rq02.1 User Model' do
        it 'User class implemented' do
          expect(class_exists?('User'))
          expect(User < ActiveRecord::Base).to eq(true)
        end
        context 'User class properties defined' do
          subject(:user) { User.new }
          it { is_expected.to respond_to(:username) }
          it { is_expected.to respond_to(:password_digest) }
          it { is_expected.to respond_to(:created_at) }
          it { is_expected.to respond_to(:updated_at) }
        end
        it 'User database structure in place' do
          expect(User.column_names).to include('password_digest', 'username')
          expect(User.column_for_attribute('username').type).to eq :string
          expect(User.column_for_attribute('password_digest').type).to eq :string
          expect(User.column_for_attribute('created_at').type).to eq :datetime
          expect(User.column_for_attribute('updated_at').type).to eq :datetime
        end
      end
      context 'rq02.2 Profile Model' do
        it 'Profile class implemented' do
          expect(class_exists?('Profile'))
          expect(Profile < ActiveRecord::Base).to eq(true)
        end
        context 'Profile class properties defined' do
          subject(:profile) { Profile.new }
          it { is_expected.to respond_to(:gender) }
          it { is_expected.to respond_to(:birth_year) }
          it { is_expected.to respond_to(:first_name) }
          it { is_expected.to respond_to(:last_name) }
          it { is_expected.to respond_to(:created_at) }
          it { is_expected.to respond_to(:updated_at) }
        end
        it 'Profile database structure in place' do
          expect(Profile.column_names).to include('gender', 'birth_year', 'first_name', 'last_name')
          expect(Profile.column_for_attribute('gender').type).to eq :string
          expect(Profile.column_for_attribute('birth_year').type).to eq :integer
          expect(Profile.column_for_attribute('first_name').type).to eq :string
          expect(Profile.column_for_attribute('last_name').type).to eq :string
          expect(User.column_for_attribute('created_at').type).to eq :datetime
          expect(User.column_for_attribute('updated_at').type).to eq :datetime
        end
      end
      context 'rq02.3 ToDoList Model' do
        it 'ToDoList class implemented' do
          expect(class_exists?('ToDoList'))
          expect(ToDoList < ActiveRecord::Base).to eq(true)
        end
        context 'ToDoList class properties defined' do
          subject(:todolist) { ToDoList.new }
          it { is_expected.to respond_to(:list_due_date) }
          it { is_expected.to respond_to(:list_name) }
          it { is_expected.to respond_to(:created_at) }
          it { is_expected.to respond_to(:updated_at) }
        end
        it 'ToDoList database structure in place' do
          # rails g model todo_list list_name list_due_date:date
          # rake db:migrate
          expect(ToDoList.column_names).to include('list_name', 'list_due_date')
          expect(ToDoList.column_for_attribute('list_name').type).to eq :string
          expect(ToDoList.column_for_attribute('list_due_date').type).to eq :date
          expect(ToDoList.column_for_attribute('created_at').type).to eq :datetime
          expect(ToDoList.column_for_attribute('updated_at').type).to eq :datetime
        end
      end
      context 'rq02.4 ToDoItem Model' do
        it 'ToDoItem class implemented' do
          expect(class_exists?('ToDoItem'))
          expect(ToDoItem < ActiveRecord::Base).to eq(true)
        end
        context 'ToDoItem class properties defined' do
          subject(:todolist) { ToDoItem.new }
          it { is_expected.to respond_to(:due_date) }
          it { is_expected.to respond_to(:title) }
          it { is_expected.to respond_to(:description) }
          it { is_expected.to respond_to(:completed) }
          it { is_expected.to respond_to(:created_at) }
          it { is_expected.to respond_to(:updated_at) }
        end
        it 'ToDoItem database structure in place' do
          # rails g model todo_item due_date:date title description:text completed:boolean
          # rake db:migrate
          expect(ToDoItem.column_names).to include('due_date', 'title', 'description', 'completed')
          expect(ToDoItem.column_for_attribute('due_date').type).to eq :date
          expect(ToDoItem.column_for_attribute('title').type).to eq :string
          expect(ToDoItem.column_for_attribute('description').type).to eq :text
          expect(ToDoItem.column_for_attribute('completed').type).to eq :boolean
          expect(ToDoItem.column_for_attribute('created_at').type).to eq :datetime
          expect(ToDoItem.column_for_attribute('updated_at').type).to eq :datetime
        end
      end
    end
  end

  context 'rq03' do
    before do
      User.destroy_all
      ToDoList.destroy_all
    end

    context 'rq03.1 assignment code has create_user method' do
      it { is_expected.to respond_to(:create_user) }
      it 'should create_user with provided parameters' do
        expect(User.find_by(username: 'joesmith')).to be_nil
        assignment.create_user(username: 'joesmith', password_digest: 'xxx')
        test_user = User.find_by username: 'joesmith'
        expect(test_user.id).not_to be_nil
        expect(test_user.username).to eq 'joesmith'
        expect(test_user.password_digest).to eq 'xxx'
        expect(test_user.created_at).not_to be_nil
        expect(test_user.updated_at).not_to be_nil
      end
    end

    context 'rq03.2 assignment code has create_todolist method' do
      it { is_expected.to respond_to(:create_todo_list) }
      it 'should create_todolist with provided parameters' do
        expect(ToDoList.find_by(list_name: 'mylist')).to be_nil
        due_date = Date.today
        params   = { name: 'mylist', due_date: due_date }
        assignment.create_todo_list(params)
        test_list = ToDoList.find_by(list_name: 'mylist')
        expect(test_list.id).not_to be_nil
        expect(test_list.list_name).to eq 'mylist'
        expect(test_list.list_due_date).to eq due_date
        expect(test_list.created_at).not_to be_nil
        expect(test_list.updated_at).not_to be_nil
      end
    end
  end

  context 'rq04' do
    before do
      User.destroy_all
      ToDoList.destroy_all
    end

    context 'rq04.1 Must retrieve paginated User results from DB' do
      it { is_expected.to respond_to(:find_all_users) }
      it 'should implement find_allusers that returns a collection of Users and
            honors offset and limit parameters' do
        last_time = Time.now
        (0..20).each do |i|
          User.create(:username => "user_#{i}", :password_digest => 'xxx')
        end
        test_users_group1 = assignment.find_all_users(0, 10)
        test_users_group2 = assignment.find_all_users(10, 5)

        # test that results are sorted by updated_at and are ascending
        test_users_group1.each do |t|
          expect(t.updated_at).to be >= last_time
          last_time = t.updated_at
        end

        # Test that limits and offset are correct
        expect(test_users_group1.length).to be(10)
        expect(test_users_group2.length).to be(5)
        expect(test_users_group1[9].username).to eq('user_9')
        expect(test_users_group2[0].username).to eq('user_10')
      end
    end

    context 'rq04.2 Must retrieve paginated ToDoList results from DB' do
      it { is_expected.to respond_to(:find_all_lists) }
      it 'should implement find_alllists that returns a collection of ToDoLists and
            honors offset and limit parameters' do
        date_base  = Date.today
        date_track = date_base
        (0..20).each do |i|
          date_track = date_base + i.day
          ToDoList.create(list_name: "list_#{i}", list_due_date: date_track)
        end
        test_lists_group1 = assignment.find_all_lists(0, 10)
        test_lists_group2 = assignment.find_all_lists(10, 5)

        # test that results are sorted by updated_at and are descending
        test_lists_group1.each do |t|
          expect(t.list_due_date).to be <= date_track
          date_track = t.list_due_date
        end

        # Test that limits and offset are correct
        expect(test_lists_group1.length).to be(10)
        expect(test_lists_group2.length).to be(5)
        expect(test_lists_group1[9].list_name).to eq('list_11')
        expect(test_lists_group2[0].list_name).to eq('list_10')
      end
    end
  end

  context 'rq05' do
    before do
      User.destroy_all
      ToDoList.destroy_all
    end

    context 'rq05.1 Must Query DB with User exact match' do
      it { is_expected.to respond_to(:find_user_by_name) }
      it 'should implement find_user_by_name to return all users with a given name' do
        User.create(username: 'rich', password_digest: 'xxx')
        User.create(username: 'bob', password_digest: 'xxx')
        User.create(username: 'joe', password_digest: 'xxx')
        User.create(username: 'rich', password_digest: 'xxx')
        expect(assignment.find_user_by_name('rich').length).to be(2)
        expect(assignment.find_user_by_name('joe').length).to be(1)
      end
    end

    context 'rq05.2 Must Query DB with ToDoList exact match' do
      it { is_expected.to respond_to(:find_todo_list_by_name) }
      it 'should implement find_todo_list_by_name to return all list with a given name' do
        ToDoList.create(list_name: 'My list', list_due_date: Date.today)
        ToDoList.create(list_name: 'Bob\'s list', list_due_date: Date.today)
        ToDoList.create(list_name: 'Joe\'s list', list_due_date: Date.today)
        ToDoList.create(list_name: 'My list', list_due_date: Date.today)
        expect(assignment.find_todo_list_by_name('My list').length).to be(2)
        expect(assignment.find_todo_list_by_name('Bob\'s list').length).to be(1)
      end
    end
  end

  context 'rq06' do
    before do
      User.destroy_all
      ToDoList.destroy_all
    end

    context 'rq06.1 Must get rows from DB by User PK' do
      it { is_expected.to respond_to(:get_user_by_id) }
      it 'should implement the get_user_byid method to return user by primary key' do
        User.create(username: 'joesmith', password_digest: 'xxx')
        test_user = User.find_by username: 'joesmith'
        expect(test_user.id).not_to be_nil
        expect(assignment.get_user_by_id(test_user.id).username).to eq('joesmith')
      end
    end

    context 'rq06.2 Must get rows from DB by ToDoList PK' do
      it { is_expected.to respond_to(:get_todo_list_by_id) }
      it 'should implement the get_todo_list_by_id method to return todo_list by primary key' do
        ToDoList.create(list_name: 'my list', list_due_date: Date.today)
        test_list = ToDoList.find_by list_name: 'my list'
        expect(test_list.id).not_to be_nil
        expect(assignment.get_todo_list_by_id(test_list.id).list_name).to eq('my list')
      end
    end
  end

  context 'rq07' do
    before do
      User.destroy_all
      ToDoList.destroy_all
    end

    context 'rq07.1 Must update User rows in database' do
      it { is_expected.to respond_to(:update_password) }
      it 'should implement update_password method with parameters id and password_digest' do
        User.create(username: 'joesmith', password_digest: 'xxx')
        test_user = User.find_by username: 'joesmith'
        assignment.update_password(test_user.id, 'newpassword')
        expect(User.find(test_user.id).password_digest).to eq('newpassword')
      end
    end

    context 'rq07.2 Must update ToDoList rows in database' do
      it { is_expected.to respond_to(:update_list_name) }
      it 'should implement update_list_name method with parameters id and name' do
        ToDoList.create(list_name: 'my list', list_due_date: Date.today)
        test_list = ToDoList.find_by list_name: 'my list'
        assignment.update_list_name(test_list.id, 'Big list')
        expect(ToDoList.find(test_list.id).list_name).to eq('Big list')
      end
    end
  end

  context 'rq08' do
    before do
      User.destroy_all
      ToDoList.destroy_all
    end

    context 'rq08.1 Must delete User rows from database' do
      it { is_expected.to respond_to(:delete_user) }
      it 'should implement delete_user method which takes a primary key parameter' do
        user = User.create(username: 'deletetest', password_digest: 'foobar')
        expect(User.find(user.id)).not_to be_nil
        assignment.delete_user(user.id)
        expect { User.find(user.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'rq08.2 Must delete ToDoList rows from database' do
      it { is_expected.to respond_to(:delete_todo_list) }
      it 'should implement delete_todo_list method which takes a primary key parameter' do
        list = ToDoList.create(list_name: 'delete list', list_due_date: Date.new(2020))
        expect(ToDoList.find(list.id)).not_to be_nil
        assignment.delete_todo_list(list.id)
        expect { ToDoList.find(list.id) }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
