class BooleanValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, :boolean || options[:message], options) unless (value == true || value == false)
  end
end
