require 'test_helper'

class UserTest < ActiveSupport::TestCase # IN THE TESTS, WE TRY TO SAVE INCORRECT DATA TO THE DATABASE
	should have_many(:user_friendships)
	should have_many(:friends)

	test "a user should enter a first name" do 
		user = User.new # creates a new user variable, user is a new instance of the User class 
		assert !user.save # tells use the user should not be saved in our database, assert asserts that something is true
		assert !user.errors[:first_name].empty? # asserts that the errors on the first_name field are not empty
	end

	test "a user should enter a last name" do 
		user = User.new
		assert !user.save # Q: asserts that the user was not saved?
		assert !user.errors[:last_name].empty? # Q: asserts that the user does not have an empty lname?
	end

	test "a user should enter a profile name" do 
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a unique profile name" do 
		user = User.new
		user.profile_name = users(:rydawg).profile_name # created a fixture
		assert !user.save
		# puts user.errors.inspect # spits out errors along the way
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a profile name without spaces" do 
		user = User.new(first_name: 'ry', last_name: 'matt', email: 'ncxkomo2@gmail.com')
		user.password = user.password_confirmation = 'afdsdsdsd'
		user.profile_name = "My Profile"

		assert !user.save # make sure that it can't be saved
		assert !user.errors[:profile_name].empty? # make sure that there are some errors in the profile name
		# we're doing this to make sure errors are registered. when we initially run the test without entering validations in the user profile, we see that errors were NOT registered. by entering validations, we confirm errors DO GET registered.
		# when i first ran this, the assertion failed because no errors were in the profile name. i don't want this, i want errors to be registered. that's why we then put in the validations.
		assert user.errors[:profile_name].include?("Must be formatted correctly.") # checks errors array with the profilename key to make sure w'ere gettting the right error
	end

	test "a user can have a properly formatted profile name" do 
		user = User.new(first_name: 'ry', last_name: 'matt', email: 'ncxkomo2@gmail.com')
		user.password = user.password_confirmation = 'afdsdsdsd'

		user.profile_name = 'mypropername_1'
		assert user.valid?
	end

	test "that no error is raised when trying to acces a friend list" do
		assert_nothing_raised do
			users(:rydawg).friends
		end
	end

	test "that creating friendships on a user works" do
		users(:rydawg).pending_friends << users(:mikey)
		users(:rydawg).pending_friends.reload
		assert users(:rydawg).pending_friends.include?(users(:mikey))
	end

	test "that calling to_param on a user returns the profile_name" do
		assert_equal "rydawg", users(:rydawg).to_param
	end

end
