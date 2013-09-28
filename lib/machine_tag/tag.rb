module MachineTag
  # A tag which can be a machine tag.
  #
  class Tag < String
    # The regular expression for matching a machine tag
    #
    # @return [Regexp] the regular expression for matching a machine tag
    MACHINE_TAG = /^(?<namespace>[a-zA-Z][a-zA-Z0-9_]*):(?<predicate>[a-zA-Z][a-zA-Z0-9_]*)=(?<value>.*)$/

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

    # Returns whether this tag is a machine tag or not.
    #
    # @return [Boolean] +true+ if this tag is a machine tag, otherwise +false+
    #
    def machine_tag?
      !!namespace
    end
  end
end
