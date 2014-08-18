class RepresentativePresenter < Presenter
  def type
    if target.type
      t "simple_form.options.representative.type.#{target.type}"
    end
  end

  present :organisation_name, :name

  def address
    AddressPresenter.present(self)
  end

  def telephone_number
    address_telephone_number
  end

  present :mobile_number, :email_address, :dx_number

  def contact_preference
    if target.contact_preference
      t "simple_form.options.claimant.contact_preference.#{target.contact_preference}"
    end
  end
end
