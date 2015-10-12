module RouteConstraints
  class RootDomain
    def self.matches?(request)
      return true unless Rails.application.config.multisite

      case request.subdomain
      when 'www', '', nil
        true
      else
        false
      end
    end
  end
end
