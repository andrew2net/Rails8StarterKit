class Admin::BaseController < ApplicationController
  layout :custom_layout

  def custom_layout
    return "turbo_rails/frame" if request.format.turbo_stream?

    "admin"
  end
end
