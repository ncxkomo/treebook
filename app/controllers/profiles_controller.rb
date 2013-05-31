class ProfilesController < ApplicationController
  def show
  	@user = User.find_by_profile_name(params[:id])
  	if @user 
  		@statuses = @user.statuses.all
  		render action: :show
	else
  		render file: 'public/404', status: 404, formats: [:html] # when web browser requests the html format, rails can't find anything, so send the 404 page
  	end
  end
end
