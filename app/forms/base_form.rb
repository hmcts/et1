class BaseForm < ApplicationRecord
  establish_connection adapter: :nulldb,
                       schema: 'config/nulldb_schema.rb'
  def form_name
    self.class.model_name_i18n_key.to_s.dasherize
  end

  def self.model_name_i18n_key
    model_name.i18n_key
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
  end

  # This is to force everything in to thinking we are doing an update all the time ( needed for I18n labels etc.. )
  # @TODO Review if this is really required
  def persisted?
    true
  end

  # @TODO This is for compatibility with old code and is naughty as it is effectively
  # bypassing strong parameters
  # @TODO Work out how to remove this
  def assign_attributes(attrs)
    attrs = attrs.to_unsafe_hash if attrs.respond_to?(:to_unsafe_hash)
    super(attrs)
  end

  def save
    if valid?
      _resource.attributes = persisted_attributes
      _resource.save
    else
      false
    end
  end

  def persisted_attributes
    attributes
  end


end
