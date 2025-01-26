class Admin::UsersController < Admin::BaseController
  before_action :authorize_user
  def index
  end

  private

  def authorize_user
    authorize %i[user], "#{action_name}?".to_sym
  end
end
