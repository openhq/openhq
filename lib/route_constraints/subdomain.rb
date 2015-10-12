module RouteConstraints
  class Subdomain
    def self.matches?(request)
      return true unless Rails.application.config.multisite

      case request.subdomain
      when 'www', '', nil
        false
      else
        true
      end
    end
  end
end
