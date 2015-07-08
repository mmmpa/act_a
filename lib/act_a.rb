module ActA
  class << self
    def call(*args)
      new(*args)
    end

    def new(klass)
      Actor.new(klass)
    end
  end

  class Actor
    attr_accessor :klass

    def initialize(klass)
      self.klass = klass
    end

    def apply(*args)
      Validator.new(klass).apply(*args)
    end
  end

  class Validator
    attr_accessor :record, :keys, :klass

    def initialize(klass)
      self.klass = klass
    end

    def apply(key_and_values = {})
      self.keys = key_and_values.keys
      self.record = klass.new(key_and_values)
      self
    end

    def errors
      record.errors
    end

    def messages
      record.errors.try(:messages)
    end

    def valid?
      validate
      errors.empty?
    end

    def valid_brutally?
      validate_brutally
      errors.empty?
    end

    def validate
      keys.each do |attribute_name|
        validators(attribute_name).each do |validator|
          duplicate_validator(validator, attribute_name).validate(record)
        end
      end
    rescue
      # do nothing
    ensure
      reject_not_target
      return self
    end

    def validate!
      if valid?
        self
      else
        raise ActiveRecord::RecordInvalid, record
      end
    end

    def validate_brutally
      record.valid?
    rescue
      # do nothing
    ensure
      reject_not_target
      return self
    end

    def validate_brutally!
      if valid_brutally?
        self
      else
        raise ActiveRecord::RecordInvalid, record
      end
    end

    private
    def validators(attribute_name)
      klass._validators[attribute_name.to_sym]
    end

    def duplicate_validator(validator, attribute_name)
      validator.class.new(validator.options.merge(attributes: attribute_name))
    end

    def reject_not_target
      return unless record.errors
      record.errors.messages.reject! { |attribute| !keys.include?(attribute) }
    end
  end
end

=begin
[
  :_validators,
  :_validate_callbacks,
  :_validate_callbacks?,
  :_validate_callbacks=,
  :_validators?,
  :_validators=,
  :_validation_callbacks,
  :_validation_callbacks?,
  :_validation_callbacks=,
  :before_validation,
  :after_validation,
  :validates_associated,
  :validates_uniqueness_of,
  :validates_presence_of,
  :validates_absence_of,
  :validates_format_of,
  :validates_inclusion_of,
  :validates_length_of,
  :validates_size_of,
  :validates_confirmation_of,
  :validates_exclusion_of,
  :validates_numericality_of,
  :validates_acceptance_of,
  :validates_each,
  :validate,
  :validators,
  :clear_validators!,
  :validators_on,
  :validates_with,
  :validates,
  :validates!,
  :_validates_default_keys,
  :_parse_validates_options
]
=end
