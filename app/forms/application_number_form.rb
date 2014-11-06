class ApplicationNumberForm < Form
  after_save :deliver_access_details

  attribute :password,      String
  attribute :email_address, String

  validates :password, presence: true

  def target
    resource
  end

  private def deliver_access_details
    AccessDetailsMailer.deliver_later(target)
  end
end
