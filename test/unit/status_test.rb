require 'test_helper'

class StatusTest < ActiveSupport::TestCase
  
  test "that a status requires content" do 
  	status = Status.new 
	assert !status.save # assert that status can't save
  	assert !status.errors[:content].empty? # assert we have an error on our content field
  end

  test "that a status requires at least two characters" do 
  	status = Status.new 
	status.content = "H"
	assert !status.save
  	assert !status.errors[:content].empty? 
  end

  test "that a status has a user id" do 
  	status = Status.new 
	status.content = "Hello"
	assert !status.save
  	assert !status.errors[:user_id].empty? 
  end

end
