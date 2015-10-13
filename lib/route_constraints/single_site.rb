module RouteConstraints
  class SingleSite
    def self.matches?(_request)
      !Rails.application.config.multisite
    end
  end
end
