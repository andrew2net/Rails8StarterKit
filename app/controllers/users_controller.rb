class UsersController < ApplicationController
  allow_unauthenticated_access only: %i[new create]

  def new
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
