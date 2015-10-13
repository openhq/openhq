module RouteConstraints
  class MultiSite
    def self.matches?(_request)
      Rails.application.config.multisite
    end
  end
end
