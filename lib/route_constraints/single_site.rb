module RouteConstraints
  class SingleSite
    def self.matches?(request)
      ! Rails.application.config.multisite
    end
  end
end
