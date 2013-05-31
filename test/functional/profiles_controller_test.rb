require 'test_helper'

class ProfilesControllerTest < ActionController::TestCase
  
  test "should get show" do
    get :show, id: users(:rydawg).profile_name # send in a profile profile_name with an id key, which rails generates automatically
    assert_response :success
    assert_template 'profiles/show' # make sure sending correct template - rails creates views/profiles/show
  end

  test "should render a 404 on profile not found" do 
  	get :show, id: "doesn't exist"
  	assert_response :not_found 
  end

test "that variables are assigned on successful profile viewing" do
    get :show, id: users(:rydawg).profile_name 
    assert assigns(:user)
    assert_not_empty assigns(:statuses)
  end

test "only shows the correct user's statuses" do 
	get :show, id: users(:rydawg).profile_name 
	assigns(:statuses).each do |status| # make sure user of status matches correct user
	assert_equal users(:rydawg), status.user
  end

end
end

