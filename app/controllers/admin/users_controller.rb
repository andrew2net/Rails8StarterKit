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
        format.turbo_stream #do
        #   render turbo_stream: turbo_stream.update("users_list", partial: "users", locals: { user: User.all })
        # end
        format.html { redirect_to admin_users_path, notice: "User was successfully created." }
      else
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("modal", partial: "invite", locals: { user: @user }),
                 status: :unprocessable_entity
        end
        format.html { render :new }
      end
    end
  end

  def show
    respond_to do |format|
      format.html # do
        # if turbo_frame_request?
        #   render partial: "user", locals: { user: @user }
        # else
        #   render :show
        # end
      # end
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
      if update_user_roles
        format.html { redirect_to [ :admin, @user ], notice: "User was successfully updated." }
        format.turbo_stream
      else
        format.html { render :edit }
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("modal", partial: "form", locals: { user: @user }),
                 status: :unprocessable_entity
        end
      end
    end
  end

  private

  def update_user_roles
    @user.roles = user_params[:roles].reject(&:empty?).map { |r| UserRole.create(role: r) }
  rescue ArgumentError => e
    @user.errors.add(:roles, e.message)
    false
  end

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    authorize %i[user], "#{action_name}?".to_sym
  end

  def user_params
    params.expect(user: [ roles: [] ])
  end

  def turbo_frame_request?
    request.headers["Turbo-Frame"].present?
  end
end
