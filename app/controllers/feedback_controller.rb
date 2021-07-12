class FeedbackController < ApplicationController
  invisible_captcha only: [:create], honeypot: :subtitle
  def create
    resource.assign_attributes params.require(:feedback).permit(:subtitle, :comments, :suggestions, :email_address)
    resource.save

    redirect_to feedback_path, flash: { info: t('.sent') }
  end

  def resource
    @resource ||= FeedbackForm.new({})
  end

  helper_method :resource
end
