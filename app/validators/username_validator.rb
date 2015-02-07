class UsernameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A[a-z0-9_-]{2,20}\z/
      record.errors[attribute] << (options[:message] || "must be all alphanumeric, lowercase and can only include - or _")
    end
  end
end
