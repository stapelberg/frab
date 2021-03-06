class Cfp::UsersController < ApplicationController

  layout 'signup'

  before_filter :authenticate_user!, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.call_for_papers = @conference.call_for_papers
    @user.person = Person.new(email: @user.email, public_name: @user.email)

    if @user.save
      redirect_to new_cfp_session_path, notice: t(:"cfp.signed_up")
    else
      render action: "new"
    end
  end

  def edit
    @user = current_user
    render layout: "cfp"
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      redirect_to cfp_person_path, notice: t(:"cfp.updated")
    else
      render action: "new"
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

end
