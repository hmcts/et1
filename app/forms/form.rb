class Form < ApplicationRecord
  self.abstract_class = true
  establish_connection adapter: :nulldb,
                       schema: 'config/nulldb_schema.rb'
  attr_reader :resource
  before_validation :clean_strings

  def initialize(resource, **attrs)
    self.resource = resource
    super(attrs)
    reload
    yield self if block_given?
  end

  def self.has_many_forms(collection_name, class_name: "#{collection_name.to_s.singularize.camelize}Form")
    class_eval do
      define_method :"#{collection_name}_proxy" do
        existing = instance_variable_get("@#{collection_name}_proxy")
        return existing unless existing.nil?

        instance_variable_set("@#{collection_name}_proxy", FormCollectionProxy.new(class_name, collection_name, self))
      end

      define_method :"#{collection_name}" do
        send("#{collection_name}_proxy")
      end

      define_method :"#{collection_name}_attributes=" do |attrs|
        send("#{collection_name}_proxy").collection_attributes = attrs
      end
    end
  end

  # Form Methods
  def form_name
    self.class.model_name_i18n_key.to_s.dasherize
  end

  def self.model_name_i18n_key
    model_name.i18n_key
  end

  def self.model_name
    ActiveModel::Name.new(self, nil, name.underscore.sub(/_form\Z/, ''))
  end

  def self.for(name)
    "#{name}_form".classify.constantize
  end

  # This is required as the standard implementation checks the connection to see if the table exists
  # but the connection is the null db adapter, which relies on the schema file to define tables.
  # However, we do not want the table 'definitions' to be defined outside of the form objects
  #
  # If this returns false, then methods dont get defined for the attributes so all attribute accesses use method_missing
  # which is slower and also it means you wont be able to do things like have_attributes in rspec on a form without this
  def self.table_exists?
    true
  end

  # target is normally the resource but can be overriden
  # @TODO - do we need to do this ?
  def target
    resource
  end

  # @TODO This is used to provide a boolean which isn't technically
  # an attribute so doesnt get output to the underlying resource
  def self.boolean(attr)
    define_method(attr) { instance_variable_get :"@#{attr}" }

    type = ActiveRecord::Type::Boolean.new

    define_method(:"#{attr}=") do |v|
      instance_variable_set :"@#{attr}", type.cast(v)
    end

    alias_method :"#{attr}?", attr
  end

  # @TODO This is used just to do multiple booleans !!  (crazy)
  def self.booleans(*attrs)
    attrs.each(&method(:boolean))
  end # This is requires as all the I18n translations are setup to use it

  # @TODO Decide whether to change or not
  def self.i18n_scope
    :activemodel
  end

  # @TODO This is for compatibility with old code and is naughty as it is effectively
  # bypassing strong parameters
  # @TODO Work out how to remove this
  def assign_attributes(attrs)
    #attrs = attrs.to_unsafe_hash if attrs.respond_to?(:to_unsafe_hash)
    super(attrs)
  end

  # This is to force everything in to thinking we are doing an update all the time ( needed for I18n labels etc.. )
  # @TODO Review if this is really required
  def persisted?
    true
  end

  # Bypasses original save and saves the target
  # @TODO Consider separating persistence from form objects
  # @TODO Why is this calling stuff on target and resource ?
  def save
    if valid?
      run_callbacks :save do
        ActiveRecord::Base.transaction do
          target.update attributes unless target.frozen?
          resource.save
        end
      end
    else
      false
    end
  end

  # Resource methods

  # Loads the form object with values from the target
  def reload
    attributes.each_key do |key|
      send "#{key}=", target.try(key)
    end
  end

  private

  attr_writer :resource

  def clean_strings
    @attributes.each_value do |attr|
      next unless attr.type.is_a?(ActiveModel::Type::String) && attr.value.is_a?(String)
      if attr.value.frozen?
        attr.value = attr.value.strip!
      else
        attr.value.strip!
      end
    end
  end

end
