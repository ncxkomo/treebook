require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user) 
  should belong_to(:friend) 

  test "that creating a friendship works without raising an exception" do
  	assert_nothing_raised do
  		UserFriendship.create user: users(:rydawg), friend: users(:mikey)
	end
  end


  test "that creating a friendship based on user id and friend id works" do
	UserFriendship.create user_id: users(:rydawg).id, friend_id: users(:mikey).id 
	assert users(:rydawg).pending_friends.include?(users(:mikey))
  end

  context "a new instance" do
    setup do
      @user_friendship = UserFriendship.new user: users(:rydawg), friend: users(:mikey)
    end

    should "have a pending state" do
      assert_equal 'pending', @user_friendship.state
    end
  end

  context "#send_request_email" do
    setup do
      @user_friendship = UserFriendship.create user: users(:rydawg), friend: users(:mikey) # create instead of new so mailer has something to talk to
    end

    should "send an email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        @user_friendship.send_request_email
      end
    end
  end

  context "#mutual_friendship" do
    setup do
      UserFriendship.request users(:rydawg), users(:jimbo)
      @friendship1 = users(:rydawg).user_friendships.where(friend_id: users(:jimbo).id).first
      @friendship2 = users(:jimbo).user_friendships.where(friend_id: users(:rydawg).id).first
    end  

    should "correctly find the mutual friendship" do
      assert_equal @friendship2, @friendship1.mutual_friendship 
    end
  end

  context "#accept_mutual_friendship!" do
    setup do
      UserFriendship.request users(:rydawg), users(:jimbo)
    end

    should "accept the mutual friendship" do
      friendship1 = users(:rydawg).user_friendships.where(friend_id: users(:jimbo).id).first
      friendship2 = users(:jimbo).user_friendships.where(friend_id: users(:rydawg).id).first

      friendship1.accept_mutual_friendship!
      friendship2.reload
      assert_equal 'accepted', friendship2.state
    end
  end

  context "#accept!" do # bang means method is potentially dangerous
    setup do
      @user_friendship = UserFriendship.request users(:rydawg), users(:mikey) # create instead of new so mailer has something to talk to
    end
  
    should "set the state to accepted" do
      @user_friendship.accept!
      assert_equal "accepted", @user_friendship.state
    end

    should "send the acceptance email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        @user_friendship.accept!
      end
    end

    should "include the friend in the list of friends" do
      @user_friendship.accept!
      users(:rydawg).friends.reload
      assert users(:rydawg).friends.include?(users(:mikey))
    end

    should "accept the mutual friendship" do 
      @user_friendship.accept!
      assert_equal 'accepted', @user_friendship.mutual_friendship.state 
    end

  end

  context ".request" do # denote class methods in contexts with a .
    should "create two user friendships" do
      assert_difference 'UserFriendship.count', 2 do
        UserFriendship.request(users(:rydawg), users(:mikey))
      end
    end

    should "send a friend request email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        UserFriendship.request(users(:rydawg), users(:mikey))
      end
    end
  end

  context "#delete_mutual_friendship!" do
    setup do
      UserFriendship.request users(:rydawg), users(:jimbo)
      @friendship1 = users(:rydawg).user_friendships.where(friend_id: users(:jimbo).id).first
      @friendship2 = users(:jimbo).user_friendships.where(friend_id: users(:rydawg).id).first  
    end

    should "delete the mutual friendship" do
      assert_equal @friendship2, @friendship1.mutual_friendship
      @friendship1.delete_mutual_friendship!
      assert !UserFriendship.exists?(@friendship2.id) # make sure doesn't exist in database
    end
  end

  context "on destroy" do
    setup do
      UserFriendship.request users(:rydawg), users(:jimbo)
      @friendship1 = users(:rydawg).user_friendships.where(friend_id: users(:jimbo).id).first
      @friendship2 = users(:jimbo).user_friendships.where(friend_id: users(:rydawg).id).first  
    end

    should "delete the mutual friendship" do
      @friendship1.destroy
      assert !UserFriendship.exists?(@friendship2.id) # make sure doesn't exist in database
    end
  end
end
