class UsernameValidator < ActiveModel::EachValidator
  USERNAME_REGEXP = /\A[a-z0-9_-]{2,20}\z/

  def validate_each(record, attribute, value)
    unless value =~ USERNAME_REGEXP
      error_msg = options.fetch(:message) { "must be all alphanumeric, lowercase and can only include - or _" }
      record.errors[attribute] << error_msg
    end
  end
end
