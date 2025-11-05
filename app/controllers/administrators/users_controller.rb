class Administrators::UsersController < Administrators::ApplicationController
  before_action :set_user, only: %i[show destroy]
  def index
    @users = User.default_order
  end

  def show
  end

  def destroy
    @user.destroy!
    redirect_to administrators_users_path, notice: t('controllers.destroyed'), status: :see_other
  end

  private

  def set_user
    @user = User.find(params.expect(:id))
  end
end
