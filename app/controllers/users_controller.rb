class UsersController < ApplicationController
  before_action :signed_in_user, 	only: [:index, :edit, :update, :destroy]
  before_action :correct_user, 		only: [:edit, :update]

  # prevent anyone except admins from using the delete method		
  before_action :admin_user, 		only: :destroy

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)    
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App, "+@user.name
      redirect_to @user
    else
      render 'new'
    end
  end

  # Utilizes the will_paginate gem (and the bootstrap-will_paginate gem) to create multiple pages.
  def index
  	@users = User.paginate(page: params[:page])
  end

  def edit
  end

  def update
  	if @user.update_attributes(user_params)
		flash[:success] = "Profile updated"
		redirect_to @user
	else
		render 'edit'
	end
  end

  def destroy
  	User.find(params[:id]).destroy
  	flash[:success] = "User deleted."
  	redirect_to users_url
  end

  private
  	def user_params
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)	
  	end

  	# Checks if a user is signed in when they attempt to view a particular page.
  	# If not, it stores the location of the page they were attempting to visit and redirects
  	#   to the sign-in page.
  	def signed_in_user
  		unless signed_in?
  			store_location
  			redirect_to signin_url, notice: "Please sign in to view this page." 
  		end
  	end

  	# Checks if the user is the same as the user for who's action they are trying to access. 
  	def correct_user
  		@user = User.find(params[:id])
  		redirect_to(root_url) unless current_user?(@user)
  	end

  	# Checks if the user's admin-boolean = true.
  	def admin_user
  		redirect_to(root_url) unless current_user.admin?
  	end

end
