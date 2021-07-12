class FormCollectionProxy
  include Enumerable
  def initialize(child_form_class_name, collection_name, parent_form_instance)
    @parent_form_instance = parent_form_instance
    @collection_name = collection_name
    @child_form_klass = child_form_class_name.safe_constantize
    @collection_wrapped = {}
    raise "Unknown class #{child_form_class_name}" if child_form_klass.nil?
  end

  def collection_attributes=(value)
    parent_form_resource.send(:"#{collection_name}_attributes=", value)
  end

  def last
    wrapped(parent_collection.last)
  end

  def build(*args)
    wrapped(parent_collection.build(*args))
  end

  def slice(*args)
    wrap_collection(parent_collection.slice(*args))
  end

  def each
    parent_collection.each do |proxied_object|
      yield wrapped(proxied_object)
    end
  end

  def clear
    parent_collection.clear
  end

  delegate_missing_to :parent_collection
  alias_method :to_ary, :to_a

  private

  attr_reader :parent_form_instance, :collection_name, :child_form_klass, :collection_wrapped

  def parent_collection
    parent_form_resource.send(collection_name)
  end

  def parent_form_resource
    @parent_form_instance.resource
  end

  def wrap(proxied_object)
    child_form_klass.new(proxied_object)
  end

  def wrapped(proxied_object)
    return collection_wrapped[proxied_object.object_id] if collection_wrapped.key?(proxied_object.object_id)

    collection_wrapped[proxied_object.object_id] = wrap(proxied_object)
  end

  def wrap_collection(proxied_collection)
    proxied_collection.map do |proxied_object|
      wrapped(proxied_object)
    end
  end
end
