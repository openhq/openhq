class SubdomainValidator < ActiveModel::EachValidator
  SUBDOMAIN_REGEXP = /\A[a-z0-9]{2,20}\z/

  def validate_each(record, attribute, value)
    if SUBDOMAIN_BLACKLIST.include?(value)
      error_msg = options.fetch(:message) { "is not allowed as a subdomain" }
      record.errors[attribute] << error_msg
    end
    unless value =~ SUBDOMAIN_REGEXP
      error_msg = options.fetch(:message) { "must be all alphanumeric and lowercase" }
      record.errors[attribute] << error_msg
    end
  end
end
