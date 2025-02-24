class Admin::UsersController < Admin::BaseController
  before_action :authorize_user
  before_action :set_user, only: %i[show edit update]

  def index
    @users = User.page(params[:page]).per(10)
  end

  def new
    @user = User.new
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def create
    @user = User.invite(params[:user][:email_address])
    respond_to do |format|
      if @user.errors.empty?
        format.turbo_stream { render :create, status: :created }
        format.html { redirect_to admin_users_path, notice: "User was successfully created." }
      else
        format.turbo_stream { render :new, status: :unprocessable_entity }
        format.html { render :new }
      end
    end
  end

  def show
    respond_to do |format|
      format.html # do
      format.turbo_stream
    end
  end

  def edit
    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def update
    respond_to do |format|
      if @user.update_roles user_params[:roles]
        format.html { redirect_to [ :admin, @user ], notice: "User was successfully updated." }
        format.turbo_stream
      else
        format.html { render :edit }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    authorize %i[user], "#{action_name}?".to_sym
  end

  def user_params
    params.expect(user: [ roles: [] ])
  end
end
