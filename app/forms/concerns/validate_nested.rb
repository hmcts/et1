module ValidateNested
  extend ActiveSupport::Concern

  private

  # Validate the associated records
  def validate_collection_association(collection_method)
    records = send(collection_method)
    records.each_with_index { |record, index| collection_valid?(collection_method, record, index) }
  end

  # Returns whether or not the collection is valid and applies any errors to
  # the parent, <tt>self</tt>, if it wasn't.
  def collection_valid?(collection_method, record, index = nil)
    unless valid = record.valid?
      record.errors.each do |error|
        attribute = normalize_collection_attribute(collection_method, index, error.attribute)
        errors.add(attribute, error.message)
      end

      record.errors.details.each_key do |attribute|
        collection_attribute =
          normalize_collection_attribute(collection_method, index, attribute).to_sym

        record.errors.details[attribute].each do |error|
          errors.details[collection_attribute] << error
          errors.details[collection_attribute].uniq!
        end
      end
    end
    valid
  end

  def normalize_collection_attribute(collection_method, index, attribute)
    "#{collection_method}[#{index}].#{attribute}"
  end
end
