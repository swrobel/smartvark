class PhoneFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless value.blank? || Phoner::Phone.valid?(value)
      object.errors[attribute] << (options[:message] || "is not a valid phone number")
    end
  end
end