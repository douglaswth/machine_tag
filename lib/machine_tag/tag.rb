module MachineTag
  # A tag which can be a machine tag.
  #
  class Tag < String
    # The regular expression for matching the namespace and predicate portions of a machine tag
    #
    # @return [Regexp] the regular expression for matching the namespace and predicate portions of a machine tag
    #
    PREFIX = /[a-z][a-z0-9_]*/i

    # The regular expression for matching a machine tag
    #
    # @return [Regexp] the regular expression for matching a machine tag
    #
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
    # @param value [String, #to_s] the value
    #
    # @return [Tag] the machine tag
    #
    # @raise [ArgumentError] if the +namespace+ or +predicate+ are not in the correct format
    #
    def self.machine_tag(namespace, predicate, value)
      raise ArgumentError, "Invalid machine tag namespace: #{namespace.inspect}" unless namespace =~ /^#{PREFIX}$/
      raise ArgumentError, "Invalid machine tag predicate: #{predicate.inspect}" unless predicate =~ /^#{PREFIX}$/

      new("#{namespace}:#{predicate}=#{value}")
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
