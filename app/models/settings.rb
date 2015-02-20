class Settings
  include ActiveModel::Model

  attr_accessor :organisation_name

  validates :organisation_name, presence: true

  def self.load
    new.tap(&:load)
  end

  def load
    self.organisation_name = Metadata.get(:organisation_name)
  end

  def persist!
    Metadata.set(:organisation_name, organisation_name)
  end

  def update(params)
    set_params(params)

    persist! if valid?
  end

  private

  def set_params(params)
    params.each do |key, value|
      method = "#{key}=".to_sym
      send(method, value) if respond_to?(method)
    end
  end

end
