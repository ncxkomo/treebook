class UserFriendship < ActiveRecord::Base
  belongs_to :user 
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'

  attr_accessible :user, :friend, :user_id, :friend_id, :state

  after_destroy :delete_mutual_friendship!

  state_machine :state, initial: :pending do
  	after_transition on: :accept, do: [:send_acceptance_email, :accept_mutual_friendship!]

  	state :requested

  	event :accept do
  		transition any => :accepted # auto create accept! method and set state to accept it for us
  	end
  end

  def self.request(user1, user2) # self keyword is for class method, so method is applied to user friendship class
  	transaction do  #ensure both of these work, so rails will keep track of it
  		friendship1 = create(user: user1, friend: user2, state: 'pending') # equivalent to user_friendship.create because in class 
  		friendship2 = create(user: user2, friend: user1, state: 'requested')

  		friendship1.send_request_email
  		friendship1
  	end
  end

  def send_request_email 
  	UserNotifier.friend_requested(id).deliver # since in the instance, can send in the id
  end

  def send_acceptance_email
  	UserNotifier.friend_request_accepted(id).deliver 
  end

  def mutual_friendship
    self.class.where({user_id: friend_id, friend_id: user_id }).first 
  end

  def accept_mutual_friendship!
    # Grab the mutual friendship and update the state without using the state machine 
    # so as not to invoke callbacks.
    mutual_friendship.update_attribute(:state, 'accepted') # don't want to use callback on state machine because infinite loop
  end

  def delete_mutual_friendship!
    mutual_friendship.delete # delete removes from db without running any of the callbacks, unlike destroy Q: what are callbacks?
  end
 
end
