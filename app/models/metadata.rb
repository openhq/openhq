class Metadata < ActiveRecord::Base
  validates_presence_of :key

  def self.get(key)
    data = where(key: key).first
    data = self.set(key, "") unless data
    data.value
  end

  def self.set(key, value)
    data = where(key: key).first_or_create
    data.update(value: value)
    data
  end

end