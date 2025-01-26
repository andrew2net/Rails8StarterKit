class Admin::DashboardController < Admin::BaseController
  before_action :authorize_dashboard
  def home
  end

  private

  def authorize_dashboard
    authorize %i[admin dashboard], "#{action_name}?".to_sym
  end
end
