# Copyright (c) 2013 Douglas Thrift
#
# MIT License
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

module MachineTag
  # The regular expression for matching the individual namespace and predicate portions of a machine tag
  #
  # @return [Regexp] the regular expression for matching the individual namespace and predicate portions of a machine tag
  #
  PREFIX = /[a-z][a-z0-9_]*/i

  # The regular expression for matching the namespace and predicate portion of a machine tag
  #
  # @return [Regexp] the regular expression for matching the namespace and predicate portion of a machine tag
  #
  NAMESPACE_AND_PREDICATE = /(?<namespace>#{PREFIX}):(?<predicate>#{PREFIX})/

  # The regular expression for matching a machine tag
  #
  # @return [Regexp] the regular expression for matching a machine tag
  #
  MACHINE_TAG = /^(?<namespace_and_predicate>#{NAMESPACE_AND_PREDICATE})=(?<value>.*)$/

  # A tag which can be a machine tag.
  #
  class Tag < String
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

    # The namespace and predicate portion of the machine tag, +nil+ if the tag is not a machine tag
    #
    # @return [String, nil] the namespace and predicate portion of the machine tag, +nil+ if the tag is not a machine tag
    #
    attr_reader :namespace_and_predicate

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
        @namespace_and_predicate = match[:namespace_and_predicate]
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
