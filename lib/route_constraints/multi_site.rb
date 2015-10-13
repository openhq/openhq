module RouteConstraints
  class MultiSite
    def self.matches?(request)
      Rails.application.config.multisite
    end
  end
end
