class CollectionForm < Form
  boolean :of_collection_type

  before_validation :reset_collection!, unless: :of_collection_type

  class << self
    def resource(klass = nil)
      if klass
        @resource = klass
      else
        @resource
      end
    end
  end

  def of_collection_type
    if defined? @of_collection_type
      @of_collection_type
    else
      @of_collection_type = relation.any?(&:persisted?)
    end
  end

  def collection_attributes=(attributes)
    # Ensure we are working with a hash not action controller parameters
    attributes = attributes.to_unsafe_hash if attributes.respond_to?(:to_unsafe_hash)
    attributes.each_with_index do |(_, resource_attributes), index|
      resource = relation[index] || relation.build

      collection[index] = self.class.resource.new(resource) do |c|
        c.assign_attributes resource_attributes
      end
    end
  end

  def collection
    @collection ||= relation.tap { |c| c.build if c.empty? }.map { |c| self.class.resource.new(c) }
  end

  def build_child
    @collection << self.class.resource.new(relation.build)
  end

  def save
    if valid?
      run_callbacks(:save) do
        ActiveRecord::Base.transaction do
          resource.save
          collection.all?(&:save)
        end
      end
    else
      false
    end
  end

  def valid?
    super # This will call validation callbacks etc... but ignore results
    collection.all?(&:valid?)
  end

  private

  def relation
    resource.send "secondary_#{resource_name}"
  end

  def reset_collection!
    relation.destroy_all
    collection.clear
  end

  def resource_name
    self.class.resource.name.underscore.match(%r{\Aadditional_(\w+)_form\/\w+\Z})[1]
  end
end
