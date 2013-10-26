module MachineTag
  # A tag which can be a machine tag.
  #
  class Tag < String
    PREFIX = /[a-z][a-z0-9_]*/i

    # The regular expression for matching a machine tag
    #
    # @return [Regexp] the regular expression for matching a machine tag
    MACHINE_TAG = /^(?<namespace>#{PREFIX}):(?<predicate>#{PREFIX})=(?<value>.*)$/

    # The namespace portion of the machine tag, +nil+ if the tag is not a machine tag
    #
    # @return [String, nil] the namespace portion of the machine tag, +nil+ if the tag is not a machine tag
    #
    attr_reader :namespace

    # The predicate portion of the machine tag, +nil+ if the tag is not a machine tag
    #
    # @return [String, nil] the predicate portion of the machine tag, +nil+ if the tag is not a machine tag
    #
    attr_reader :predicate

    # The value portion of the machine tag, +nil+ if the tag is not a machine tag
    #
    # @return [String, nil] the value portion of the machine tag is not a machine tag
    #
    attr_reader :value

    # Creates a tag object which can be a machine tag.
    #
    # @param str [String] the tag string
    #
    def initialize(str)
      super
      if match = self.match(MACHINE_TAG)
        @namespace = match[:namespace]
        @predicate = match[:predicate]
        @value = match[:value]
        @value = $1 if @value =~ /^"(.*)"$/
      end
    end

    # Creates a machine tag from a given namespace, predicate, and value.
    #
    # @param namespace [String] the namespace
    # @param predicate [String] the predicate
    # @param value [String, Array, #to_s] the value
    #
    # @option options [String] :separator (',') the separator to use when +value+ is an +Array+
    #
    # @return [Tag] the machine tag
    #
    def self.machine_tag(namespace, predicate, value, options = {})
      raise ArgumentError, "Invalid machine tag namespace: #{namespace.inspect}" unless namespace =~ /^#{PREFIX}$/
      raise ArgumentError, "Invalid machine tag predicate: #{predicate.inspect}" unless predicate =~ /^#{PREFIX}$/

      options[:separator] ||= ','

      case value
      when Array
        new("#{namespace}:#{predicate}=#{value.join(options[:separator])}")
      else
        new("#{namespace}:#{predicate}=#{value}")
      end
    end

    # Returns whether this tag is a machine tag or not.
    #
    # @return [Boolean] +true+ if this tag is a machine tag, otherwise +false+
    #
    def machine_tag?
      !!namespace
    end
  end
end
