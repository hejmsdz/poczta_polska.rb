module PocztaPolska
  # This helper module is +include+d into other classes
  # and allows to access elements nested in the +@data+ hash.
  # In order to use it, a class must define a constant hash +ATTR_MAP+.
  # For the following element in the hash:
  #
  # +my_method: [:some, :nested, :value, :to_s]+
  #
  # calling +object.my_method+ will return @data[:some][:nested][:value].to_s.
  # The last element in the array is either a conversion method name, a +Proc+ or +nil+.
  module DynamicReader
    # Returns +true+ if the method name is a key in the +ATTR_MAP+ hash.
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
