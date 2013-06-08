FactoryGirl.define do
	factory :user do  # first factory for user, sets up a user
		first_name 'First' # when creating, can override any of these attributes
		last_name 'Last'
		sequence(:email) {|n| "user#{n}@example.com" } # these have to be unique, but sequence will increment number each time called (user1, user2)
		sequence(:profile_name) {|n| "user#{n}"}
		
		password "mypassword"
		password_confirmation "mypassword"
	end

	factory :user_friendship do # factory 2
		association :user, factory: :user # both associations to user factory
		association :friend, factory: :user

		factory :pending_user_friendship do # inside the friendship factory
			state 'pending'
		end

		factory :requested_user_friendship do
			state 'requested'
		end

		factory :accepted_user_friendship do
			state 'accepted'
		end
	end
end