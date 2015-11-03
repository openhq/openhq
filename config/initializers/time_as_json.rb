module ActiveSupport
  class TimeWithZone
    def as_json(options = nil)
      time.iso8601
    end
  end
end
