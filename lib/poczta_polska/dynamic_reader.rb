module PocztaPolska
  module DynamicReader
    def respond_to_missing?(method, include_private = false)
      self.class::ATTR_MAP.has_key?(method) || super
    end

    def method_missing(method)
      return super unless respond_to_missing?(method)

      keys = self.class::ATTR_MAP[method].dup
      convert = keys.pop
      d = @data
      keys.each { |k| d = d[k] }

      if convert.nil?
        d
      elsif convert.is_a?(Proc)
        convert.call(d)
      else
        d.public_send(convert)
      end
    end
  end
end
