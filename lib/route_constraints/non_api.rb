module RouteConstraints
  class NonApi
    def self.matches?(request)
      !request.fullpath.start_with?('/api/')
    end
  end
end
